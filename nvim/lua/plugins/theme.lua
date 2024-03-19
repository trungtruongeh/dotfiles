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
    lazy = false,
    config = function()
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme [[everforest]]
    end,
    enabled = true,
  },
  {
    'sainnhe/sonokai',
    lazy = true,
    config = function()
      vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme [[sonokai]]
    end,
    enabled = false,
  },
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true
      vim.g.nord_cursorline_transparent = false
      vim.g.nord_enable_sidebar_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
      vim.cmd.colorscheme [[nord]]
    end,
    enabled = false,
  },
}
