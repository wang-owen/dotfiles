return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
  config = function()
    -- lazygit.nvim refocuses the original window on exit, so jump to the tab opened by `e`
    local new_tab
    vim.api.nvim_create_autocmd('TabNewEntered', {
      callback = function()
        if vim.g.lazygit_opened == 1 then
          new_tab = vim.api.nvim_get_current_tabpage()
        end
      end,
    })
    vim.g.lazygit_on_exit_callback = function()
      if new_tab and vim.api.nvim_tabpage_is_valid(new_tab) then
        vim.api.nvim_set_current_tabpage(new_tab)
      end
      new_tab = nil
    end
  end,
}
