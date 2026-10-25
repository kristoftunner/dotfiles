-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

-- LSP logging off; set to "WARN" when debugging a language server
vim.lsp.log.set_level("OFF")

-- no python plugins; skips spawning python3 to probe for pynvim on every .py open
vim.g.loaded_python3_provider = 0
