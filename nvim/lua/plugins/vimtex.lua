return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    if vim.uv.os_uname().sysname == 'Darwin' then
      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_skim_activate = 0
    end
    vim.g.vimtex_compiler_latexmk = {
      out_dir = 'build',
    }
    vim.g.vimtex_compiler_clean_on_terminate = 1
    vim.g.vimtex_quickfix_ignore_filters = {
      'Underfull \\hbox',
      'Overfull \\hbox',
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function() vim.bo.formatprg = 'tex-fmt --stdin' end,
    })
  end,
}
