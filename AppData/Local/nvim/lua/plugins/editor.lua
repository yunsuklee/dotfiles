return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      {
        '<leader>sh',
        '<cmd>Telescope help_tags<cr>',
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        '<cmd>Telescope keymaps<cr>',
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        '<cmd>Telescope find_files<cr>',
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        '<cmd>Telescope builtin<cr>',
        desc = '[S]earch [S]elect Telescope',
      },
      {
        '<leader>sw',
        '<cmd>Telescope grep_string<cr>',
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        '<cmd>Telescope live_grep<cr>',
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        '<cmd>Telescope diagnostics<cr>',
        desc = '[S]earch [D]iagnostics',
      },
      { '<leader>sr', '<cmd>Telescope resume<cr>', desc = '[S]earch [R]esume' },
      {
        '<leader>s.',
        '<cmd>Telescope oldfiles<cr>',
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        '<cmd>Telescope buffers<cr>',
        desc = '[ ] Find existing buffers',
      },

      -- Find hidden files as well
      {
        '<leader>sF',
        function()
          require('telescope.builtin').find_files { hidden = true }
        end,
        desc = '[S]earch [F]iles (including hidden)',
      },

      -- Slightly advanced example of overriding default behavior and theme
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            }
          )
        end,
        desc = '[/] Fuzzily search in current buffer',
      },

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch [/] in Open Files',
      },

      -- Shortcut for searching your Neovim configuration files
      {
        '<leader>sn',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.stdpath 'config',
          }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'echasnovski/mini.icons' },
    },
    config = function()
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },

  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'BufRead',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      highlight = {
        keyword = 'bg',
        pattern = [[.*<(KEYWORDS).*:]],
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.files').setup {
        content = {
          filter = function(entry)
            return entry.name ~= '.git' and entry.name ~= 'node_modules'
          end,
          sort = function(entries)
            -- Sort directories first, then files
            local dirs, files = {}, {}
            for _, entry in ipairs(entries) do
              if entry.fs_type == 'directory' then
                table.insert(dirs, entry)
              else
                table.insert(files, entry)
              end
            end
            table.sort(dirs, function(a, b)
              return a.name < b.name
            end)
            table.sort(files, function(a, b)
              return a.name < b.name
            end)
            vim.list_extend(dirs, files)
            return dirs
          end,
        },
        mappings = {
          close = 'q',
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
          reset = '<BS>',
          reveal_cwd = '@',
          show_help = 'g?',
          synchronize = '=',
          trim_left = '<',
          trim_right = '>',
        },
        options = {
          permanent_delete = true,
          use_as_default_explorer = true,
        },
        windows = {
          preview = true,
          width_focus = 25,
          width_preview = 25,
        },
      }
      vim.keymap.set('n', '<leader>e', function()
        require('mini.files').open()
      end, { desc = 'Open mini.files' })

      vim.keymap.set('n', '<leader>E', function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0))
      end, { desc = 'Open mini.files (current file)' })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN:TOTAL_LINES
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%2c:%L'
      end

      -- Remove filename from statusline for all windows
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_filename = function()
        return ''
      end

      -- Make inactive statuslines completely empty
      statusline.config.content = {
        active = statusline.config.content.active,
        inactive = function()
          return ''
        end,
      }

      -- Set up winbar (topbar) to show filename with unsaved changes indicator
      vim.o.winbar = '%f%m'
    end,
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help ibl`
    main = 'ibl',
    event = 'VeryLazy',
    opts = {},
  },

  { -- autopairs
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    keys = {
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open all folds',
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close all folds',
      },
      {
        'z1',
        function()
          require('ufo').closeFoldsWith(1)
        end,
        desc = 'Close folds level 1',
      },
      {
        'z2',
        function()
          require('ufo').closeFoldsWith(2)
        end,
        desc = 'Close folds level 2',
      },
      {
        'z3',
        function()
          require('ufo').closeFoldsWith(3)
        end,
        desc = 'Close folds level 3',
      },
      {
        'z4',
        function()
          require('ufo').closeFoldsWith(4)
        end,
        desc = 'Close folds level 4',
      },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(
        virtText,
        lnum,
        endLnum,
        width,
        truncate
      )
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    end,
  },
  { -- Navigate diagnostics, references, and quickfix items
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'chrisgrieser/nvim-spider',
    event = 'VeryLazy',
    keys = {
      {
        'gw',
        '<cmd>lua require("spider").motion("w")<CR>',
        mode = { 'n', 'o', 'x' },
        desc = 'Spider-w',
      },
      {
        'ge',
        '<cmd>lua require("spider").motion("e")<CR>',
        mode = { 'n', 'o', 'x' },
        desc = 'Spider-e',
      },
      {
        'gb',
        '<cmd>lua require("spider").motion("b")<CR>',
        mode = { 'n', 'o', 'x' },
        desc = 'Spider-b',
      },
    },
    opts = {
      skipInsignificantPunctuation = true,
    },
  },
  {
    'nvim-pack/nvim-spectre',
    keys = {
      {
        '<leader>S',
        '<cmd>lua require("spectre").toggle()<CR>',
        desc = 'Toggle Spectre',
      },
      {
        '<leader>sw',
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        desc = 'Search current word',
      },
      {
        '<leader>sw',
        '<esc><cmd>lua require("spectre").open_visual()<CR>',
        mode = 'v',
        desc = 'Search current word',
      },
      {
        '<leader>sp',
        '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        desc = 'Search on current file',
      },
    },
    opts = {},
  },
}
