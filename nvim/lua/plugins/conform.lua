return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    format_on_save = { lsp_format = 'fallback' },
    formatters_by_ft = {
      lua = { 'stylua' },
      cpp = { 'clang-format' },
      c = { 'clang-format' },
      python = { 'black' },
      rust = { 'rustfmt' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
    },
  },
}
