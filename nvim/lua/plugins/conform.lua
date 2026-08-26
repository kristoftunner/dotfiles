return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        objc = { "clang-format" },
        objcpp = { "clang-format" },
        cuda = { "clang-format" },
        proto = { "clang-format" },
        rust = { "rustfmt", lsp_format = "fallback" },
      },
      formatters = {
        rustfmt = {
          -- pick the edition up from Cargo.toml instead of assuming 2021
          options = { default_edition = "2024" },
        },
      },
    },
  },

  -- Make sure Mason installs clang-format so :ConformInfo finds it.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clang-format" })
    end,
  },
}
