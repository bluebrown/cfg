local ok, plugin = pcall(require, "todo-comments")
if not ok then return end

plugin.setup({
  search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
  highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
})
