return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      globalstatus = true,
    },
    tabline = {
      lualine_a = { { 'tabs', mode = 2 } },
    },
  },
}
