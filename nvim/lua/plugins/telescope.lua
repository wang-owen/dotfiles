return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'jvgrootveld/telescope-zoxide' },
  },
  keys = {
    ---SNACKS PICKERS---
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, mode = { 'n', 'v' }, desc = '[S]earch current [W]ord' },
    { '<leader>sb', function() Snacks.picker.buffers() end, desc = '[S]earch [B]uffers' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = '[S]earch [C]ommands' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = '[S]earch [Q]uickfix' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },

    ---TELESCOPE EXTENSIONS---
    { '<leader>sz', function() require('telescope').extensions.zoxide.list() end, desc = '[S]earch [Z]oxide' },
    { '<leader>ss', function() require('telescope.builtin').builtin() end, desc = '[S]earch [S]elect Telescope' },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'zoxide')
  end,
}
