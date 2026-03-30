return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { '<leader>t', function() Snacks.terminal() end, mode = 'n', desc = 'Toggle Terminal' },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification history' },
  },
  opts = {
    notifier = { enabled = true, timeout = 5000, style = 'fancy' },
    terminal = {
      enabled = true,
      win = {
        position = 'float',
        height = 0.8,
        width = 0.8,
      },
    },
    picker = {
      enabled = true,
      formatters = { file = { filename_first = true } },
      win = {
        input = {
          keys = {
            ['<C-x>'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        explorer = { hidden = true },
        files = {
          ignored = false,
          hidden = true,
        },
      },
    },
  },
}
