return {
  'christoomey/vim-tmux-navigator',
  init = function() vim.g.tmux_navigator_no_mappings = 1 end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
  },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', mode = { 'n', 't' } },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', mode = { 'n', 't' } },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', mode = { 'n', 't' } },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', mode = { 'n', 't' } },
  },
}
