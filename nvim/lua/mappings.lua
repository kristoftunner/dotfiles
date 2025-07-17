require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- prevent esc from changing tabs
--vim.keymap.set("n", "<Esc>", "<Nop>", {silent = true})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- diffview remaps
vim.keymap.set("n", "<leader>gp", "<cmd> Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>gd", "<cmd> Git diffthis<CR>")

vim.keymap.set('t', '<leader>tq', "<C-\\><C-n>",{silent = true})

--lsp
vim.keymap.set("n", "<leader>p", "<cmd> ClangdSwitchSourceHeader<CR>")

-- TODO: add here 
return {
  n = { ["<leader>gd"] = { "<cmd>Git diffthis<CR>", "Diffing this file" },},
  t = {["<leader>tq"] = { "<C-\\><C-n>", "Exit from terminal model"}},
}

