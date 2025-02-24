-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Map Ctrl+C to copy
map("v", "<C-c>", '"+y', opts) -- Visual mode: copy to clipboard

-- Map Ctrl+V to paste
map("i", "<C-v>", "<C-r>+", opts) -- Insert mode: paste from clipboard
map("n", "<C-v>", '"+p', opts) -- Normal mode: paste from clipboard
map("v", "<C-v>", '"+p', opts) -- Visual mode: paste over selection

-- Map Ctrl+Z to undo
map("n", "<C-z>", "u", opts) -- Normal mode: undo
map("i", "<C-z>", "<C-o>u", opts) -- Insert mode: temporarily enter normal mode and undo
