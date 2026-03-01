vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })

vim.keymap.set('i', '<A-BS>', '<C-w>', { desc = 'Delete word before cursor' })
vim.keymap.set('i', '<S-Tab>', '<C-d>', { desc = 'Un-indent' })

-- Copy line down
vim.keymap.set('n', '<A-S-Down>', ':copy .<CR>', { desc = 'Copy line down' })
vim.keymap.set('i', '<A-S-Down>', '<Esc>:copy .<CR>gi', { desc = 'Copy line down' })
vim.keymap.set('v', '<A-S-Down>', ":copy '> <CR>gv", { desc = 'Copy selection down' })

-- Copy line up
vim.keymap.set('n', '<A-S-Up>', ':copy .-1<CR>', { desc = 'Copy line up' })
vim.keymap.set('i', '<A-S-Up>', '<Esc>:copy .-1<CR>gi', { desc = 'Copy line up' })
vim.keymap.set('v', '<A-S-Up>', ":copy '<-1<CR>gv", { desc = 'Copy selection up' })

-- Drag lines
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('i', '<A-Down>', '<Esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-Up>', '<Esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-Down>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize splits
vim.keymap.set('n', '<C-S-H>', '2<C-w><', { desc = 'Shrink window width' })
vim.keymap.set('n', '<C-S-L>', '2<C-w>>', { desc = 'Grow window width' })
vim.keymap.set('n', '<C-S-J>', '2<C-w>+', { desc = 'Grow window height' })
vim.keymap.set('n', '<C-S-K>', '2<C-w>-', { desc = 'Shrink window height' })
