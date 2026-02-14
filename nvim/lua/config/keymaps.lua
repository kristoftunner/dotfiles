local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map({ "n", "v" }, "<leader>d", [["_d]])

map('n', '<Tab>', ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')

-- diffview remaps
map("n", "<leader>gp", "<cmd> Gitsigns preview_hunk<CR>")
map("n", "<leader>grh", "<cmd> Gitsigns reset_hunk<CR>")
map("n", "<leader>gd", "<cmd> Git diffthis<CR>")

-- LSP
map("n", "<leader>p", "<cmd> LspClangdSwitchSourceHeader<CR>", { desc = "Change header/source" })
