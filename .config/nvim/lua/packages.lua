MiniDeps.now(function()
  -- theme
  MiniDeps.add("catppuccin/nvim")

  -- lsp configs
  MiniDeps.add("neovim/nvim-lspconfig")

  -- file nav
  MiniDeps.add("stevearc/oil.nvim")

  -- syntax
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = {
      post_checkout = function() vim.cmd("TSUpdate") end,
    },
  })

  -- finder
  MiniDeps.add({
    source = "nvim-telescope/telescope.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  })

  -- completion
  MiniDeps.add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
  })

  -- auto format
  MiniDeps.add("stevearc/conform.nvim")

  -- linter
  MiniDeps.add("mfussenegger/nvim-lint")

  -- git diff
  MiniDeps.add("echasnovski/mini.nvim")

  -- todo comments
  MiniDeps.add("folke/todo-comments.nvim")

  -- tools installer
  MiniDeps.add("williamboman/mason.nvim")
end)
