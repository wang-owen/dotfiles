return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = { signs = false },
  keys = {
    { '<leader>st', function() Snacks.picker.pick 'todo_comments' end, desc = '[S]earch [T]odos' },
  },
}
