-- Only renvim-treesitter/nvim-treesitterqnvim-treesitter/nvim-treesitteruired if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { {
      'nvim-lua/plenary.nvim',
      'IllustratedMan-code/telescope-conda.nvim'
    } }
  }

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  })

  use({
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = true,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  })


  use "tpope/vim-fugitive"
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use ("sindrets/diffview.nvim")
  use("nvim-treesitter/playground")
  use("mbbill/undotree")
  use("nvim-treesitter/nvim-treesitter-context");
  use {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup({
        float = {
          relative = 'editor',
          row = 0.3,
          col = 0.25,
          width = 0.5,
          height = 0.4,
          border = "single",
        },
        horizontal = { location = "rightbelow", split_ratio = .3, },
        vertical = { location = "rightbelow", split_ratio = .5 },
      })
    end,
  }


  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {                            -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    }
  }

  use({
    'nvim-tree/nvim-tree.lua',
    as = 'nvim-tree',
  })
  use({
    'nvim-tree/nvim-web-devicons',
    as = 'nvim-web-devicons',
  })

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-web-devicons', opt = true },
  }

  use {
    'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons'
  }

  use   'lewis6991/gitsigns.nvim'
end)

