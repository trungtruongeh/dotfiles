return {
  "iamcco/markdown-preview.nvim",
  config = function()
    vim.fn["mkdp#util#install"]()
  end,
  ft = "markdown",
  dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
}
