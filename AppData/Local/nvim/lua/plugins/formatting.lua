return {
  { -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim',
    event = 'BufReadPost', -- Load after file content is loaded
    opts = {},
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre', 'BufReadPost' }, -- Load when saving or opening files
    cmd = 'ConformInfo', -- Also load when command is used
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        ['*'] = { 'trim_whitespace' },
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        cs = { 'csharpier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
    },
  },
}
