local ok, plugin = pcall(require, "lint")
if not ok then return end

plugin.linters_by_ft = require("settings").lint
