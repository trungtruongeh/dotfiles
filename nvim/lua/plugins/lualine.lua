return {
  { "SmiteshP/nvim-gps" },
  { 'WhoIsSethDaniel/lualine-lsp-progress.nvim' },
  {
    'nvim-lualine/lualine.nvim',
    event = "BufReadPre",
    dependencies = { 'nvim-tree/nvim-web-devicons', 'WhoIsSethDaniel/lualine-lsp-progress.nvim', 'folke/noice.nvim', opt = true },
    options = { theme = 'everforest' },
    config = function()
      local gps = require "nvim-gps"
      local lsp_status = require "lsp-status"
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = vim.g.colors_name,
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
            { 'filename', lsp_status.status },
            {
              gps.get_location,
              cond = gps.is_available,
              color = { fg = "#f3ca28" },
            },
            'lsp_progress',
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

