vim.opt.termguicolors = true -- Enable 24-bit RGB color

vim.opt.number = true -- Show line numbers
vim.opt.mouse = 'a' -- Enable mouse support in all modes
vim.opt.showmode = false -- Hide mode indicator (e.g. -- INSERT --), shown in statusline instead

vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
vim.opt.cmdheight = 0 -- Hide cmdline when not in use

vim.opt.breakindent = true -- Wrapped lines continue visually indented
vim.opt.undofile = true -- Persist undo history across sessions

vim.opt.ignorecase = true -- Case-insensitive search by default
vim.opt.smartcase = true -- Override ignorecase when search includes uppercase

vim.opt.signcolumn = 'yes' -- Always show sign column to avoid layout shifts
vim.opt.updatetime = 250 -- Faster CursorHold events (ms)
vim.opt.timeoutlen = 300 -- Shorter key sequence timeout (ms)

vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below

vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Symbols for tab, trailing space, non-breaking space

vim.opt.inccommand = 'split' -- Preview substitutions live in a split
vim.opt.cursorline = true -- Highlight the current line
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor
vim.opt.confirm = true -- Ask to save instead of erroring on unsaved changes
