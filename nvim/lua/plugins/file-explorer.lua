return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
      'nvim-tree/nvim-web-devicons',
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
        custom = { ".git" },
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    }
  end
}
