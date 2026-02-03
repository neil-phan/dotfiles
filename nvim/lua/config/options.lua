vim.g.autoformat = false

-- Use terminal background instead of colorscheme background
local function transparent_bg()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "StatusLine",
    "StatusLineNC",
  }
  for _, group in ipairs(groups) do
    vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent_bg })
vim.api.nvim_create_autocmd("VimEnter", { callback = transparent_bg })
