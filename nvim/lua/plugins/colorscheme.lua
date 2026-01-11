return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    dependencies = {
      "LazyVim/LazyVim",
    },
    opts = {
      transparent_background = true,
      flavour = "mocha",
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
    },
  },
}
