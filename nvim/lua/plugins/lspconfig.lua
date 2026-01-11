return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "mason-org/mason.nvim",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "clangd", "ruff", "lua_ls", "mypy", "clang-format", "black" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "cpp",
        "python",
        "json",
      },
    },
  },
}
