return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  config = function()
    require("toggleterm").setup({
      shade_terminals = false,
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      highlights = {
        StatusLine = { guifg = "#ffffff", guibg = "#0E1018" },
        StatusLineNC = { guifg = "#ffffff", guibg = "#0E1018" }
      },
      direction = "vertical"
    })
  end,
}
