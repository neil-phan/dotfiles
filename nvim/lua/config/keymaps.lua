vim.api.nvim_create_user_command("Ts", function(opts)
	vim.cmd("Telescope " .. opts.args)
end, {
	nargs = "*",
	complete = function(arg_lead)
		local builtins = require("telescope.builtin")
		local list = vim.tbl_keys(builtins)
		table.sort(list)
		return vim.tbl_filter(function(s)
			return s:find(arg_lead, 1, true) == 1
		end, list)
	end,
})
