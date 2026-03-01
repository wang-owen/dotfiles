return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { '<leader>t', function() Snacks.terminal() end, mode = 'n', desc = 'Toggle Terminal' },
  },
  opts = {
    notifier = {
      timeout = 5000,
      top_down = false,
      style = 'fancy',
    },
    scroll = {},
    terminal = {
      enabled = true,
      win = {
        position = 'float',
        border = 'rounded',
        height = 0.8,
        width = 0.8,
      },
    },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ['<C-x>'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
          exclude = {
            '.git',
            '.DS_Store',
            '.Trash',
            '.cache',
            '.npm',
            '.node_modules',
            '.venv',
            '.env',
            '__pycache__',
            '.vscode',
            '.cargo',
            'CMakeFiles',
            'CMakeCache.txt',
          },
        },
      },
    },
    image = {},
  },
}
