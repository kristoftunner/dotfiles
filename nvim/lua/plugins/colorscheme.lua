return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "moon", -- 'main' (darkest), 'moon', 'dawn' (light)
      dark_variant = "moon",
      styles = {
        transparency = false,
      },
    },
  },
  -- kept around so <leader>uC can still flip back
  { "ellisonleao/gruvbox.nvim", lazy = true, opts = { contrast = "hard" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine-moon" } },
}
