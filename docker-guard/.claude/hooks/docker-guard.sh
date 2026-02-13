#!/usr/bin/env bash
# docker-guard.sh — Claude Code PreToolUse hook
#
# Blocks commands that can harm the HOST machine or external systems.
# Container-internal damage is explicitly allowed (containers are disposable).
#
# Threat model: Claude Code running with --dangerously-skip-permissions
# inside a Docker container. We protect against:
#   1. Container escape to host
#   2. Docker socket abuse
#   3. Network attack tools
#   4. Supply chain poisoning (package publishing)
#   5. Data exfiltration via hidden channels
#   6. Cryptomining / resource abuse
#   7. Fork bombs / resource exhaustion
#   8. Destructive remote git operations
#   9. Cloud infrastructure destruction
#  10. Pipe-to-shell remote code execution
#
# Requires: jq
set -eu

# ── Dependency check (fail closed) ──
if ! command -v jq &>/dev/null; then
  echo "[docker-guard] BLOCKED: jq is required but not found. Install it: apt-get install -y jq" >&2
  exit 2
fi

INPUT=$(cat)
COMMAND=$(jq -r '.tool_input.command // empty' <<< "$INPUT")
[[ -z "$COMMAND" ]] && exit 0

# ── Helpers ──
deny() {
  jq -n --arg r "[docker-guard] $1" \
    '{ hookSpecificOutput: { hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r } }'
  exit 0
}

# Substring check — fast, no deps beyond bash, sufficient for unique tool names
has() { [[ "$COMMAND" == *"$1"* ]]; }

# Regex check — for multi-word patterns and flag combinations
matches() { [[ "$COMMAND" =~ $1 ]]; }


# ═══════════════════════════════════════════════════════════════
# 1. CONTAINER ESCAPE — break out to host kernel/filesystem
# ═══════════════════════════════════════════════════════════════
has "nsenter"                       && deny "Container escape: nsenter"
has "insmod"                        && deny "Container escape: insmod (loads host kernel module)"
has "modprobe"                      && deny "Container escape: modprobe (loads host kernel module)"
has "/proc/sysrq-trigger"          && deny "Container escape: sysrq-trigger (can crash/reboot host)"
has "/proc/sys/kernel/core_pattern" && deny "Container escape: core_pattern (host-level code execution)"
has "release_agent"                 && deny "Container escape: cgroup release_agent (host code execution)"
has "notify_on_release"             && deny "Container escape: cgroup notify_on_release"
matches 'unshare.*--user'           && deny "Container escape: unshare --user (privilege escalation)"
matches 'mount.*/dev/(sd|nvme|vd|dm-)' && deny "Container escape: mounting host block device"


# ═══════════════════════════════════════════════════════════════
# 2. DOCKER SOCKET ABUSE — if /var/run/docker.sock is mounted,
#    these give full control over the host
# ═══════════════════════════════════════════════════════════════
has "docker.sock"                   && deny "Docker socket: direct access to host Docker daemon"
matches 'docker.*--privileged'      && deny "Docker socket: spawning --privileged container"
matches 'docker.*-v[[:space:]]+/:/[[:alnum:]]' && deny "Docker socket: mounting host root filesystem"


# ═══════════════════════════════════════════════════════════════
# 3. NETWORK ATTACK TOOLS — reach targets outside the container
# ═══════════════════════════════════════════════════════════════
for tool in \
  hping3 ettercap arpspoof bettercap responder \
  slowloris goldeneye \
  masscan \
  hydra medusa ncrack hashcat \
  msfconsole msfvenom msfpayload \
  aircrack-ng airmon-ng aireplay-ng airodump-ng; do
  has "$tool" && deny "Attack tool: $tool"
done


# ═══════════════════════════════════════════════════════════════
# 4. SUPPLY CHAIN — publishing poisoned packages affects everyone
# ═══════════════════════════════════════════════════════════════
matches 'npm[[:space:]]+publish'    && deny "Supply chain: npm publish"
matches 'yarn[[:space:]]+publish'   && deny "Supply chain: yarn publish"
matches 'pnpm[[:space:]]+publish'   && deny "Supply chain: pnpm publish"
matches 'twine[[:space:]]+upload'   && deny "Supply chain: twine upload (PyPI)"
matches 'cargo[[:space:]]+publish'  && deny "Supply chain: cargo publish (crates.io)"
matches 'gem[[:space:]]+push'       && deny "Supply chain: gem push (RubyGems)"
matches 'docker[[:space:]]+push'    && deny "Supply chain: docker push"
matches 'helm[[:space:]]+push'      && deny "Supply chain: helm push"
matches 'npm[[:space:]]+(adduser|login|token[[:space:]]+create)' \
                                    && deny "Supply chain: npm registry authentication"
matches 'npm[[:space:]]+config[[:space:]]+set[[:space:]]+registry' \
                                    && deny "Supply chain: changing npm registry"


# ═══════════════════════════════════════════════════════════════
# 5. DATA EXFILTRATION — hidden network channels
# ═══════════════════════════════════════════════════════════════
has "/dev/tcp/"                     && deny "Exfiltration: /dev/tcp/ bash built-in socket"
has "/dev/udp/"                     && deny "Exfiltration: /dev/udp/ bash built-in socket"
has "socat"                         && deny "Exfiltration: socat (network swiss-army knife)"
has "rclone"                        && deny "Exfiltration: rclone (cloud storage sync)"


# ═══════════════════════════════════════════════════════════════
# 6. CRYPTOMINING — consumes host CPU/memory through cgroups
# ═══════════════════════════════════════════════════════════════
for miner in xmrig xmr-stak cpuminer cgminer bfgminer minerd; do
  has "$miner" && deny "Cryptominer: $miner"
done
has "stratum+tcp://"                && deny "Cryptomining: stratum pool connection"
has "stratum+ssl://"                && deny "Cryptomining: stratum pool connection"
has "stratum+udp://"                && deny "Cryptomining: stratum pool connection"
matches 'nice[[:space:]]+-n[[:space:]]+-20' \
                                    && deny "Resource abuse: max CPU priority"


# ═══════════════════════════════════════════════════════════════
# 7. FORK BOMBS / RESOURCE EXHAUSTION — can starve host via cgroups
# ═══════════════════════════════════════════════════════════════
has ":(){"                          && deny "Fork bomb detected"
has ":(){ :|:& };"                  && deny "Fork bomb detected"
matches 'fork[[:space:]]+while[[:space:]]+fork' \
                                    && deny "Fork bomb: perl-style"
has "os.fork()"                     && deny "Fork bomb: python os.fork()"
matches 'ulimit[[:space:]]+-u[[:space:]]+unlimited' \
                                    && deny "Resource exhaustion: removing process limit"
matches 'ulimit[[:space:]]+-n[[:space:]]+unlimited' \
                                    && deny "Resource exhaustion: removing file descriptor limit"


# ═══════════════════════════════════════════════════════════════
# 8. DESTRUCTIVE GIT — affects remote repositories, not container
# ═══════════════════════════════════════════════════════════════
# Allow --force-with-lease (safe), block bare --force and -f
matches 'git[[:space:]]+push.*--force' && ! has "--force-with-lease" \
                                    && deny "Destructive git: push --force (use --force-with-lease)"
matches 'git[[:space:]]+push[[:space:]].*-f[[:space:]]' \
                                    && deny "Destructive git: push -f (use --force-with-lease)"
matches 'git[[:space:]]+filter-branch' \
                                    && deny "Destructive git: filter-branch rewrites shared history"
matches 'git[[:space:]]+filter-repo' \
                                    && deny "Destructive git: filter-repo rewrites shared history"
matches 'git[[:space:]]+update-ref[[:space:]]+-d' \
                                    && deny "Destructive git: update-ref -d deletes refs"
matches 'git[[:space:]]+reflog[[:space:]]+expire' \
                                    && deny "Destructive git: reflog expire destroys safety net"


# ═══════════════════════════════════════════════════════════════
# 9. CLOUD CLI DESTRUCTIVE — credentials often leak into containers
#    via env vars or mounted config directories
# ═══════════════════════════════════════════════════════════════
# AWS
matches 'aws[[:space:]]+s3[[:space:]]+rm.*--recursive' \
                                    && deny "Cloud: aws s3 rm --recursive"
matches 'aws[[:space:]]+s3[[:space:]]+rb' \
                                    && deny "Cloud: aws s3 rb (remove bucket)"
matches 'aws[[:space:]]+ec2[[:space:]]+terminate-instances' \
                                    && deny "Cloud: aws ec2 terminate-instances"
matches 'aws[[:space:]]+rds[[:space:]]+delete-db-instance' \
                                    && deny "Cloud: aws rds delete-db-instance"
matches 'aws[[:space:]]+cloudformation[[:space:]]+delete-stack' \
                                    && deny "Cloud: aws cloudformation delete-stack"
matches 'aws[[:space:]]+iam[[:space:]]+delete-user' \
                                    && deny "Cloud: aws iam delete-user"
matches 'aws[[:space:]]+lambda[[:space:]]+delete-function' \
                                    && deny "Cloud: aws lambda delete-function"
matches 'aws[[:space:]]+ecs[[:space:]]+delete-cluster' \
                                    && deny "Cloud: aws ecs delete-cluster"

# GCP
matches 'gcloud[[:space:]]+projects[[:space:]]+delete' \
                                    && deny "Cloud: gcloud projects delete"
matches 'gcloud[[:space:]]+compute[[:space:]]+instances[[:space:]]+delete' \
                                    && deny "Cloud: gcloud compute instances delete"
matches 'gcloud[[:space:]]+sql[[:space:]]+instances[[:space:]]+delete' \
                                    && deny "Cloud: gcloud sql instances delete"
matches 'gcloud[[:space:]]+storage[[:space:]]+rm.*--recursive' \
                                    && deny "Cloud: gcloud storage rm --recursive"

# Azure
matches 'az[[:space:]]+group[[:space:]]+delete' \
                                    && deny "Cloud: az group delete"
matches 'az[[:space:]]+vm[[:space:]]+delete' \
                                    && deny "Cloud: az vm delete"
matches 'az[[:space:]]+storage[[:space:]]+account[[:space:]]+delete' \
                                    && deny "Cloud: az storage account delete"
matches 'az[[:space:]]+sql[[:space:]]+db[[:space:]]+delete' \
                                    && deny "Cloud: az sql db delete"

# Terraform
matches 'terraform[[:space:]]+destroy' \
                                    && deny "Cloud: terraform destroy"
matches 'terraform[[:space:]]+apply.*-auto-approve' \
                                    && deny "Cloud: terraform apply -auto-approve (no plan review)"

# Kubernetes
matches 'kubectl[[:space:]]+delete[[:space:]]+(namespace|ns)[[:space:]]' \
                                    && deny "Cloud: kubectl delete namespace"
matches 'kubectl[[:space:]]+delete.*--all' \
                                    && deny "Cloud: kubectl delete --all"
matches 'helm[[:space:]]+uninstall' \
                                    && deny "Cloud: helm uninstall"


# ═══════════════════════════════════════════════════════════════
# 10. PIPE-TO-SHELL — remote code execution, can persist via
#     mounted volumes even after container dies
# ═══════════════════════════════════════════════════════════════
matches 'curl.*\|[[:space:]]*(bash|sh|zsh|fish|dash)' \
                                    && deny "Pipe-to-shell: curl piped to interpreter"
matches 'wget.*\|[[:space:]]*(bash|sh|zsh|fish|dash)' \
                                    && deny "Pipe-to-shell: wget piped to interpreter"
matches 'base64[[:space:]]+(-d|--decode).*\|[[:space:]]*(bash|sh|zsh|fish|dash)' \
                                    && deny "Pipe-to-shell: base64 decode piped to interpreter"


# ── All checks passed ──
exit 0
