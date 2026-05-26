return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'lua',
      'vim',
      'vimdoc',
      'query',
      'c',
      'cpp',
      'python',
      'rust',
      'typescript',
    }

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable Treesitter highlighting & indentation',
      pattern = { 'lua', 'vim', 'help', 'query', 'c', 'cpp', 'python', 'rust', 'typescript' },
      callback = function()
        pcall(vim.treesitter.start)
        pcall(function() vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end)
      end,
    })
  end,
}
