local ok, plugin = pcall(require, "oil")
if not ok then return end

plugin.setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _)
      if name == ".." then return true end
      if name == ".git" then return true end
    end,
  },
  win_options = {
    wrap = true,
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>")
