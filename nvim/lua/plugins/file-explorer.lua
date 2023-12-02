return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "DaikyXendo/nvim-material-icon",
    },
    config = function()
      local nvim_tree = require "nvim-tree"
      nvim_tree.setup {
        disable_netrw = false,
        hijack_netrw = true,
        respect_buf_cwd = true,
        view = {
          width = 50,
          number = true,
          relativenumber = true,
        },
        filters = {
          dotfiles = false
        },
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      }
    end,
  },
  {
    "DaikyXendo/nvim-material-icon",
    config = function()
      require'nvim-material-icon'.setup {
        -- your personnal icons can go here (to override)
        -- you can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        };
        -- globally enable different highlight colors per icon (default to true)
        -- if set to false all icons will have the default icon's color
        color_icons = true;
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true;
      }
    end
  }
}
