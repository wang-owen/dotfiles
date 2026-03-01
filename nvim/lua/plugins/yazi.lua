return {
  'mikavilpas/yazi.nvim',
  keys = {
    { '<leader>-', '<cmd>Yazi<cr>', mode = { 'n', 'v' }, desc = 'Open yazi at the current file' },
    { '<leader>cw', '<cmd>Yazi cwd<cr>', desc = "Open yazi in nvim's working directory" },
    { '<leader>y', '<cmd>Yazi toggle<cr>', desc = 'Resume the last yazi session' },
  },
  opts = { open_for_directories = true },
}
