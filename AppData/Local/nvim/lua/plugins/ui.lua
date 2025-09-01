return {
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
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = '[H]arpoon' },
        { '<leader>g', group = '[G]it Hunk', mode = { 'n', 'v' } },
      },
    },
  },
  { -- Integrated terminal
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = 'ToggleTerm',
    keys = {
      {
        '<C-\\>',
        '<cmd>ToggleTerm<cr>',
        desc = 'Toggle terminal',
        mode = { 'n', 't' },
      },
      {
        '<leader>th',
        '<cmd>ToggleTerm direction=horizontal size=15<cr>',
        desc = 'Horizontal terminal',
      },
      {
        '<leader>tv',
        '<cmd>ToggleTerm direction=vertical size=80<cr>',
        desc = 'Vertical terminal',
      },
      {
        '<leader>tf',
        '<cmd>ToggleTerm direction=float<cr>',
        desc = 'Floating terminal',
      },
    },
    opts = {
      shell = vim.fn.has 'win32' == 1 and 'pwsh' or vim.o.shell,
      direction = 'float',
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
  },
}
