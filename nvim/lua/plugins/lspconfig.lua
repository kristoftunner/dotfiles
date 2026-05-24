require("mason-lspconfig").setup()

require("lspconfig").clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  on_attach = function(client, bufnr)
    -- Keymaps
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<lender>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,   opts)
  end
})
return {
}
