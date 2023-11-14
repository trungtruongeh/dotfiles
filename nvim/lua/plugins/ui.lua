return {
  -- Color theme
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
    enabled = false,
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme [[everforest]]
    end,
    enabled = false,
  },
  {
    'sainnhe/sonokai',
    config = function()
      vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme [[sonokai]]
    end,
    enabled = true,
  },
}
