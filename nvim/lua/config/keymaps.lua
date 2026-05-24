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

map({ "n", "v" }, "<leader>d", [["_d]])
map('n', '<Tab>', ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })


-- diffview remaps
map("n", "<leader>gp", "<cmd> Gitsigns preview_hunk<CR>")
map("n", "<leader>grh", "<cmd> Gitsigns reset_hunk<CR>")
map("n", "<leader>gd", "<cmd> Git diffthis<CR>")

-- LSP
map("n", "<leader>p", "<cmd> ClangdSwitchSourceHeader<CR>", { desc = "Change header/source" })

-- getting rid of a weird lazyvim mapping
map("n", "k", "k", { noremap = true, silent = true })
map("n", "j", "j", { noremap = true, silent = true })

-- DAP
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Continue" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: Step Over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: Step Into" })
map("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: Step Out" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Debug: Open REPL" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Debug: Toggle UI" })
