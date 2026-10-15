vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

-- In an OrbStack Linux machine, route the clipboard through macOS
if vim.fn.has 'linux' == 1 and vim.fn.executable 'mac' == 1 then
  vim.g.clipboard = {
    name = 'orbstack',
    copy = { ['+'] = { 'mac', 'pbcopy' }, ['*'] = { 'mac', 'pbcopy' } },
    paste = { ['+'] = { 'mac', 'pbpaste' }, ['*'] = { 'mac', 'pbpaste' } },
    cache_enabled = 0,
  }
end

vim.opt.cmdheight = 0

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
