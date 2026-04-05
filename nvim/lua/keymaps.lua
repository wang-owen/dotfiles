vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })

vim.keymap.set('i', '<A-BS>', '<C-w>', { desc = 'Delete word before cursor' })
vim.keymap.set('i', '<A-Del>', '<C-o>dw', { desc = 'Delete word after cursor' })
vim.keymap.set('i', '<S-Tab>', '<C-d>', { desc = 'Un-indent' })

-- Copy line down
vim.keymap.set('n', '<A-S-Down>', ':copy .<CR>', { desc = 'Copy line down' })
vim.keymap.set('i', '<A-S-Down>', '<Esc>:copy .<CR>gi', { desc = 'Copy line down' })
vim.keymap.set('x', '<A-S-Down>', ":copy '><CR>`[V`]", { desc = 'Copy selection down' })

-- Copy line up
vim.keymap.set('n', '<A-S-Up>', ':copy .-1<CR>', { desc = 'Copy line up' })
vim.keymap.set('i', '<A-S-Up>', '<Esc>:copy .-1<CR>gi', { desc = 'Copy line up' })
vim.keymap.set('x', '<A-S-Up>', ":copy '<-1<CR>`[V`]", { desc = 'Copy selection up' })

-- Drag lines
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('i', '<A-Down>', '<Esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-Up>', '<Esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('x', '<A-Down>', ":move '>+1<CR>`[V`]", { desc = 'Move selection down' })
vim.keymap.set('x', '<A-Up>', ":move '<-2<CR>`[V`]", { desc = 'Move selection up' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Resize splits
vim.keymap.set('n', '<A-h>', '2<C-w><', { desc = 'Shrink window width' })
vim.keymap.set('n', '<A-l>', '2<C-w>>', { desc = 'Grow window width' })
vim.keymap.set('n', '<A-j>', '2<C-w>+', { desc = 'Grow window height' })
vim.keymap.set('n', '<A-k>', '2<C-w>-', { desc = 'Shrink window height' })
