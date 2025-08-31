return {
  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   lazy = false,
  --   config = function()
  --     require('tokyonight').setup {
  --       style = 'night',
  --       styles = {
  --         comments = { italic = false }, -- Disable italics in comments
  --       },
  --     }
  --
  --     -- vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     require('gruvbox').setup {
  --       -- contrast = 'hard', -- can be "hard", "soft" or empty string
  --       italic = {
  --         comments = false,
  --       },
  --       transparent_mode = false,
  --     }
  --
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- },
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'catppuccin-mocha' -- or frappe, macchiato, latte
  --   end,
  -- }
  -- {
  --   'shaunsingh/nord.nvim',
  --   config = function()
  --     vim.cmd.colorscheme 'nord'
  --   end,
  -- }
  -- {
  --   'projekt0n/github-nvim-theme',
  --   config = function()
  --     vim.cmd.colorscheme 'github_dark'
  --   end,
  -- }
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function()
  --     vim.cmd.colorscheme 'rose-pine' -- or rose-pine-moon, rose-pine-dawn
  --   end,
  -- }
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('nightfox').setup {
        options = {
          -- Disable italics in comments and keywords
          styles = {
            comments = 'NONE',
            keywords = 'NONE',
            types = 'NONE',
          },
        },
      }

      vim.cmd.colorscheme 'nightfox'
    end,
  },
}
