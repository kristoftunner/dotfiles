-- Use clang-format for C/C++/etc. clang-format walks up from the file
-- being formatted and picks up the nearest .clang-format automatically,
-- so dropping a .clang-format into the project root (or the dir you start
-- nvim in) is all that's needed.
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
      },
      -- Use clang-format's own .clang-format discovery; do not pass
      -- --style=file so it walks up from the buffer's directory.
      formatters = {
        ["clang-format"] = {
          prepend_args = {},
        },
      },
    },
  },

  -- Make sure Mason installs clang-format so :ConformInfo finds it.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clang-format" })
    end,
  },
}
