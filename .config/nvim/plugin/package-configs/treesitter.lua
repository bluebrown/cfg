local ok, install = pcall(require, "nvim-treesitter.install")
if not ok then return end

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

install.prefer_git = true

configs.setup({
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = { enable = false },
  indent = { enable = false },
  ensure_installed = require("settings").syntax,
})
