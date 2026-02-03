return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			-- Make lualine background transparent
			local transparent = { bg = "NONE" }
			opts.options = opts.options or {}
			opts.options.theme = {
				normal = { a = transparent, b = transparent, c = transparent },
				insert = { a = transparent, b = transparent, c = transparent },
				visual = { a = transparent, b = transparent, c = transparent },
				replace = { a = transparent, b = transparent, c = transparent },
				command = { a = transparent, b = transparent, c = transparent },
				inactive = { a = transparent, b = transparent, c = transparent },
			}
		end,
	},
}
