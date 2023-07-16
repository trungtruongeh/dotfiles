return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bd", "<Cmd>bd!<Cr>", desc = "Delete buffer" },
    { "<leader>bD", "<Cmd>%bd|e#|bd#<Cr>", desc = "Delete all other buffers" },
    { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<leader>bs", "<Cmd>BufferLinePickClose<CR>", desc = "Pick and close buffer" },
    { "<leader>bt", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer to next position" },
    { "<leader>bT", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer to previous position" },
  },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diag)
        local icons = require("config").icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
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
