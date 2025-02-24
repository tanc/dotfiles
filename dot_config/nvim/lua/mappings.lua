require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({"v", "i"}, "<R-C-c>", "+y", { desc = "Right control + c yank text", noremap = true, silent = true })
map("v", "<C-c>", '"+y', opts) -- Visual mode: copy to clipboard
map("v", "<D-c>", '"+y', opts) -- Visual mode: copy to clipboard
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
