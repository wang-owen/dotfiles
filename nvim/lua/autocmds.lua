vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Export final Neovim cwd for shell synchronization',
  group = vim.api.nvim_create_augroup('export-nvim-cwd', { clear = true }),
  callback = function()
    local cwd_file = vim.env.NVIM_CWD_FILE
    if not cwd_file or cwd_file == '' then return end

    local ok, err = pcall(vim.fn.writefile, { vim.fn.getcwd() }, cwd_file)
    if not ok then vim.notify('Failed to write NVIM_CWD_FILE: ' .. tostring(err), vim.log.levels.DEBUG) end
  end,
})
