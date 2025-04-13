local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd("echo \"Installing `mini.nvim`\" | redraw")
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd("echo \"Installed `mini.nvim`\" | redraw")
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- style
now(function()
	add("catppuccin/nvim")
	require("catppuccin").setup({
		transparent_background = true,
		show_end_of_buffer = true,
		term_colors = true,
		default_integrations = true,
		integrations = {
			treesitter = true,
			cmp = true,
			native_lsp = {
				enabled = true,
				inlay_hints = {
					background = true,
				},
			},
		},
	})
	vim.cmd.colorscheme("catppuccin")
end)

-- buffer based file edits
now(function()
	add("stevearc/oil.nvim")
	require("oil").setup({
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				if name == ".." then
					return true
				end
				if name == ".git" then
					return true
				end
			end,
		},
		win_options = {
			wrap = true,
		},
	})
	vim.keymap.set("n", "-", "<CMD>Oil<CR>")
end)

-- syntax highlighting
later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.install").prefer_git = true
	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		auto_install = false,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		incremental_selection = { enable = false },
		indent = { enable = false },
		ensure_installed = require("deps").syntax,
	})
end)

now(function()
	add("williamboman/mason.nvim")
	require("mason").setup()
	local want = require("deps").tools
	local need = {}
	for _, t in pairs(want) do
		local p = vim.fn.stdpath("data") .. "/mason/packages/" .. t
		if not vim.loop.fs_stat(p) then
			table.insert(need, t)
		end
	end
	if #need > 0 then
		vim.cmd({ cmd = "MasonInstall", args = need })
	end
end)

-- language server
-- needs to load early so lsp attach runs on first bufEnter
now(function()
	add("neovim/nvim-lspconfig")
	local lc = require("lspconfig")
	--
	-- NOTE: servers have to be installed manually!
	lc.gopls.setup({})
	lc.rust_analyzer.setup({})
	lc.pyright.setup({})
	lc.bashls.setup({})

	-- - "K" is mapped in Normal mod to |vim.lsp.buf.hover()|
	-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
	-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
	-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
	-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
	vim.keymap.set("n", "grd", vim.lsp.buf.definition)
	vim.keymap.set("n", "grq", vim.diagnostic.setqflist)

	vim.keymap.set("n", "K", function()
		if not vim.diagnostic.open_float() then
			vim.lsp.buf.hover()
		end
	end)
end)

-- linter
later(function()
	add("mfussenegger/nvim-lint")
	require("lint").linters_by_ft = {
		markdown = { "markdownlint" },
		sh = { "shellcheck" },
		terraform = { "tflint", "tfsec" },
	}
	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = lint_augroup,
		callback = function()
			require("lint").try_lint()
			require("lint").try_lint("cspell")
		end,
	})
end)

-- auto format
later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			markdown = { "markdownlint" },
			json = { "jq" },
			yaml = { "yamlfmt" },
			sh = { "shfmt" },
			c = { "clang-format" },
			go = { "goimports" },
			python = { "isort", "black" },
			hcl = { "hcl" },
			toml = { "taplo" },
			rust = { "rustfmt" },
		},
		notify_on_error = false,
		format_on_save = function(buf)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[buf].filetype],
			}
		end,
	})
end)

-- fuzzy finder
later(function()
	add({
		source = "nvim-telescope/telescope.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
	})
	require("telescope").setup({
		defaults = {
			mappings = {
				i = { ["<c-enter>"] = "to_fuzzy_refine" },
			},
		},
		pickers = {
			find_files = { find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" } },
			grep_string = { additional_args = { "--hidden" } },
			live_grep = { additional_args = { "--hidden" } },
		},
		extensions = {
			["ui-select"] = { require("telescope.themes").get_dropdown() },
		},
	})
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ss", builtin.builtin)
	vim.keymap.set("n", "<leader>sh", builtin.help_tags)
	vim.keymap.set("n", "<leader>sk", builtin.keymaps)
	vim.keymap.set("n", "<leader>sf", builtin.find_files)
	vim.keymap.set("n", "<leader>sw", builtin.grep_string)
	vim.keymap.set("n", "<leader>sg", builtin.live_grep)
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
	vim.keymap.set("n", "<leader>sr", builtin.resume)
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
	vim.keymap.set("n", "<leader><leader>", builtin.buffers)
	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end)
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end)
end)

later(function()
	add("L3MON4D3/LuaSnip")
	add("hrsh7th/nvim-cmp")
	add("saadparwaiz1/cmp_luasnip")
	add("hrsh7th/cmp-nvim-lsp")
	add("hrsh7th/cmp-path")

	local cmp = require("cmp")
	local luasnip = require("luasnip")
	luasnip.config.setup({})

	local cmp_winconf = cmp.config.window.bordered({
		winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
	})

	cmp.setup({
		window = {
			completion = cmp_winconf,
			documentation = cmp_winconf,
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		completion = { completeopt = "menu,menuone,noinsert" },

		mapping = cmp.mapping.preset.insert({
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete({}),

			["<C-l>"] = cmp.mapping(function()
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { "i", "s" }),

			["<C-h>"] = cmp.mapping(function()
				if luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { "i", "s" }),
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
		},
	})
end)

-- mini plugins collections
later(function()
	add("echasnovski/mini.nvim")
end)

-- show git diff
later(function()
	require("mini.diff").setup()
end)

-- todo comments
later(function()
	add("folke/todo-comments.nvim")
	require("todo-comments").setup({
		search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
		highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
	})
end)
