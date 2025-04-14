local ok, plugin = pcall(require, "catppuccin")
if not ok then return end

plugin.setup({
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
