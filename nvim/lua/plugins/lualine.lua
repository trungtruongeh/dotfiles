return {
  { "SmiteshP/nvim-gps" },
  {
    'nvim-lualine/lualine.nvim',
    event = "BufReadPre",
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/noice.nvim', opt = true },
    options = { theme = 'everforest' },
    config = function()
      local gps = require "nvim-gps"
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 700,
            tabline = 700,
            winbar = 700,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            { 'filename' },
            {
              gps.get_location,
              cond = gps.is_available,
              color = { fg = "#f3ca28" },
            },
          },
          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            },
            'searchcount',
            'encoding',
            'fileformat'
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },
}

