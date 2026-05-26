return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Terminals & Notifier
    { '<leader>t', function() Snacks.terminal() end, mode = 'n', desc = 'Toggle Terminal' },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification history' },

    -- Finder/Search
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord' },
    { '<leader>sb', function() Snacks.picker.buffers() end, desc = '[S]earch [B]uffers' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = '[S]earch [C]ommands' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = '[S]earch [Q]uickfix' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent' },
    { '<leader>sz', function() Snacks.picker.zoxide() end, desc = '[S]earch [Z]oxide' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },
  },
  opts = {
    notifier = { enabled = true, timeout = 5000, style = 'fancy' },
    select = { enabled = true },
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
