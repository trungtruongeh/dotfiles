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
    enabled = false,
  },
  {
    'sainnhe/sonokai',
    lazy = false,
    config = function()
      vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme [[sonokai]]
    end,
    enabled = false,
  },
  {
    'maxmx03/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function ()
      ---@type dracula
      local dracula = require "dracula"

      dracula.setup({
      transparent = false,
      on_colors = function (colors, color)
        ---@type dracula.palette
        return {
          -- override or create new colors
          mycolor = "#ffffff",
        }
      end,
      on_highlights = function (colors, color)
        ---@type dracula.highlights
        return {
          ---@type vim.api.keyset.highlight
          Normal = { fg = colors.mycolor }
        }
      end,
      plugins = {
        ["nvim-treesitter"] = true,
        ["nvim-lspconfig"] = true,
        ["nvim-navic"] = true,
        ["nvim-cmp"] = true,
        ["indent-blankline.nvim"] = true,
        ["neo-tree.nvim"] = true,
        ["nvim-tree.lua"] = true,
        ["which-key.nvim"] = true,
        ["dashboard-nvim"] = true,
        ["gitsigns.nvim"] = true,
        ["neogit"] = true,
        ["todo-comments.nvim"] = true,
        ["lazy.nvim"] = true,
        ["telescope.nvim"] = true,
        ["noice.nvim"] = true,
        ["hop.nvim"] = true,
        ["mini.statusline"] = true,
        ["mini.tabline"] = true,
        ["mini.starter"] = true,
        ["mini.cursorword"] = true,
      }
      })
      vim.cmd.colorscheme 'dracula'
      vim.cmd.colorscheme 'dracula-soft'
    end
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
