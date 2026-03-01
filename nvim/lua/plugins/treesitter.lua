return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
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
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
