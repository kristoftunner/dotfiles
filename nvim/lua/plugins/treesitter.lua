return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Clear LazyVim's ensure_installed list to skip parser install checks on startup.
      -- Use :TSInstall <lang> to install parsers manually.
      opts.ensure_installed = {}
      opts.auto_install = false
      return opts
    end,
  },
}
