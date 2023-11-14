return {
  "akinsho/bufferline.nvim",
  dependencies = { "echasnovski/mini.nvim" },
  event = "VeryLazy",
  keys = {
    { "<leader>bd", "<Cmd>bd!<Cr>", desc = "Delete buffer" },
    { "<leader>bo", "<Cmd>%bd|e#|bd#<Cr>", desc = "Delete all other buffers" },
    { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<leader>bs", "<Cmd>BufferLinePickClose<CR>", desc = "Pick and close buffer" },
    { "<leader>bm", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer to next position" },
    { "<leader>bM", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer to previous position" },
  },
  opts = {
    options = {
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)

        -- local icons = require("config").icons.diagnostics
        -- -- local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        --   .. (diag.warning and icons.Warn .. diag.warning or "")
        -- return vim.trim(ret)

        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      -- offsets = {
      --   {
      --     filetype = "neo-tree",
      --     text = "Neo-tree",
      --     highlight = "Directory",
      --     text_align = "left",
      --   },
      -- },
    },
  },
}
