return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  opts = {
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {
      '<C-u>',
      '<C-d>',
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
    },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = true, -- Stop scrolling when cursor reaches scrolloff margin
    cursor_scrolls_alone = true, -- Cursor keeps scrolling even if window cannot scroll further
    easing_function = linear, -- Default easing function (can be 'linear', 'quadratic', 'cubic', 'quartic', 'quintic', 'circular', 'sine')
    performance_mode = true, -- Disable "Performance Mode" on all buffers
    -- Optional: customize scroll duration (in milliseconds)
    scroll_duration = 50,
  },
}
