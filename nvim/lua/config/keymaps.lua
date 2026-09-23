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
map("n", "<leader>p", "<cmd> LspClangdSwitchSourceHeader<CR>", { desc = "Change header/source" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Formatting
local function format()
  require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
    if err then
      vim.notify(err, vim.log.levels.WARN, { title = "Format" })
    end
  end)
end

map("n", "=", format, { desc = "Format" })
map("n", "<leader>=", format, { desc = "Format" })
map("v", "=", function()
  format()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Format" })
map("v", "<leader>=", function()
  format()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Format" })

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
map("n", "<leader>dq", function() require("dap").terminate() end, { desc = "Debug: Terminate" })
map("n", "<leader>dc", function() require("dap").run_to_cursor() end, { desc = "Debug: Run to Cursor" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Debug: Run Last" })
map("n", "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, { desc = "Debug: Eval" })
map("v", "<leader>de", function() require("dapui").eval() end, { desc = "Debug: Eval Selection" })
