return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Terminals & Notifier
    { '<leader>t', function() Snacks.terminal() end, mode = 'n', desc = 'Toggle Terminal' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
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

    -- Diagnostics
    { '<leader>xx', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>xX', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },

    { '<leader>z', function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
  },
  opts = {
    dashboard = {
      preset = {
        header = table.concat({
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠼⠟⠛⠛⠣⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⢠⡿⠋⠃⠀⠀⠀⠀⠀⠀⠘⠟⢄⡀⠀⠀⠀⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⢀⡼⡟⣯⡿⠛⠛⠿⠕⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠺⣃⠀⠀⠀⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⣀⠰⠟⠛⠻⠿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠶⠶⢆⣀⠀⠀⠀]],
          [[⠀⠀⣠⡾⠉⠀⠀⠀⠀⠀⠑⠃⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠈⢻⡷⣀⠀]],
          [[⢀⣼⠇⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆]],
          [[⢸⡇⠀⠈⢀⠀⠀⠀⠀⠀⠀⠀⡆⢀⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⠀⠀⠀⠴⡀⠀⠀⠰⠀⢸⡇]],
          [[⠀⢱⣆⠀⠈⠓⠒⠒⠚⢅⣶⡊⠀⠈⠸⡉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠆⠈⠀⠀⠀⣾⠁]],
          [[⠀⠀⠛⢗⣐⣠⣤⣐⣾⣿⣿⣷⣀⡄⢀⡠⢡⣶⣶⣶⡀⠀⠀⠀⠀⠀⡰⢧⣀⣼⣶⣾⠟⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠉⢿⡼⠿⢿⣿⡿⠋⠉⠉⠉⠸⣿⠯⣿⣶⣶⣶⣿⡿⠏⠉⠉⠁⠀⠀⠀⠀]],
          [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠋⠉⠀⠀⠀⠀⠀⠀⠀⠋⠻⠿⠿⠏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        }, '\n'),
        keys = {
          { icon = '\u{f002} ', key = 'b', desc = 'Browse Files', action = ':Yazi' },
          { icon = '\u{f0968} ', key = 'd', desc = 'Browse Directories', action = function() Snacks.picker.zoxide() end },
          { icon = '\u{f0c7c} ', key = 'f', desc = 'Find File', action = function() Snacks.picker.files() end },
          { icon = '\u{f017} ', key = 'r', desc = 'Recent', action = function() Snacks.picker.recent() end },
        },
      },
      sections = { { section = 'header' }, { section = 'keys', gap = 1 } },
    },
    indent = { animate = { enabled = false } },
    scroll = {},
    zen = {},
    notifier = { timeout = 5000, style = 'fancy' },
    terminal = {
      win = {
        position = 'float',
        height = 0.8,
        width = 0.8,
      },
    },
    picker = {
      formatters = { file = { filename_first = true } },
      win = {
        input = {
          keys = {
            ['<C-x>'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        explorer = { hidden = true, ignored = false },
        files = { hidden = true, ignored = false },
      },
    },
  },
}
