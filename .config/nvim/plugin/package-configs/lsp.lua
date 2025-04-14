for _, ls in pairs(require("settings").lsp) do
  vim.lsp.enable(ls)
end
