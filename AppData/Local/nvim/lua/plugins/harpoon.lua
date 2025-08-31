return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon'):list():add()
      end,
      desc = '[A]dd file to harpoon',
    },
    {
      '<leader>h',
      function()
        require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
      end,
      desc = '[H]arpoon menu',
    },
    {
      '<leader>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'Harpoon file 1',
    },
    {
      '<leader>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'Harpoon file 2',
    },
    {
      '<leader>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'Harpoon file 3',
    },
    {
      '<leader>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'Harpoon file 4',
    },
    {
      '<C-S-P>',
      function()
        require('harpoon'):list():prev()
      end,
      desc = 'Previous harpoon file',
    },
    {
      '<C-S-N>',
      function()
        require('harpoon'):list():next()
      end,
      desc = 'Next harpoon file',
    },
  },
  config = function()
    require('harpoon'):setup()
    -- NOTE: telescope extension will be loaded when telescope loads
    require('telescope').load_extension 'harpoon'
  end,
}
