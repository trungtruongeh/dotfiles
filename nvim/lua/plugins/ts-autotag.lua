return {
  'windwp/nvim-ts-autotag',
  ft = "typescriptreact, javascriptreact, html",
  event = "BufRead",
  config = function ()
    require('nvim-ts-autotag').setup()
  end
}
