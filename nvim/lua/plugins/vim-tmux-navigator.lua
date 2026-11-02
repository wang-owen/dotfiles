local function nav(cmd, tmux_dir)
  return function()
    -- in a float (yazi, lazygit, snacks terminal), go straight to tmux so focus stays on the float
    if vim.env.TMUX and vim.api.nvim_win_get_config(0).relative ~= '' then
      vim.fn.system { 'tmux', 'select-pane', '-' .. tmux_dir }
    else
      vim.cmd(cmd)
    end
  end
end

return {
  'christoomey/vim-tmux-navigator',
  init = function() vim.g.tmux_navigator_no_mappings = 1 end,
  keys = {
    { '<C-h>', nav('TmuxNavigateLeft', 'L'), mode = { 'n', 't' } },
    { '<C-j>', nav('TmuxNavigateDown', 'D'), mode = { 'n', 't' } },
    { '<C-k>', nav('TmuxNavigateUp', 'U'), mode = { 'n', 't' } },
    { '<C-l>', nav('TmuxNavigateRight', 'R'), mode = { 'n', 't' } },
  },
}
