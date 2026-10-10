local parsers = { 'lua', 'vim', 'vimdoc', 'query', 'c', 'cpp', 'python', 'rust', 'typescript' }

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install(parsers)

    local filetypes = {}
    for _, lang in ipairs(parsers) do
      vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
    end

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable Treesitter highlighting & indentation',
      pattern = filetypes,
      callback = function()
        pcall(vim.treesitter.start)
        pcall(function() vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end)
      end,
    })
  end,
}
