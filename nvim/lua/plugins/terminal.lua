return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  config = function()
    require("toggleterm").setup({
      shade_terminals = false,
      highlights = {
        StatusLine = {guifg = "#ffffff", guibg = "#0E1018"},
        StatusLineNC = {guifg = "#ffffff", guibg = "#0E1018"}
      }
    })
  end,
}
