return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup()

    treesitter.install = {
      'c',
      'cpp',
      'javascript',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'rust',
      'typescript',
      'vim',
      'vimdoc',
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'c',
        'cpp',
        'javascript',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'rust',
        'typescript',
        'vim',
        'vimdoc',
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
