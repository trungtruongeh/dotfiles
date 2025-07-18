return {
  {
    'tomasky/bookmarks.nvim',
    event = "VeryLazy",
    config = function()
      require('bookmarks').setup {
        save_file = vim.fn.expand "$HOME/.bookmarks",
        on_attach = function()
          local whichkey = require "which-key"

          local opts = {
            mode = "n",     -- Normal mode
            prefix = "<leader>",
            buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
            silent = true,  -- use `silent` when creating keymaps
            noremap = true, -- use `noremap` when creating keymaps
            nowait = false, -- use `nowait` when creating keymaps
          }

          whichkey.register({
            m = {
              name = "Markbooks",
              m = { "<cmd>lua require('bookmarks').bookmark_toggle()<CR>", "Toggle Bookmark" },
              i = { "<cmd>lua require('bookmarks').bookmark_ann()<CR>", "Edit Bookmark" },
              c = { "<cmd>lua require('bookmarks').bookmark_clean()<CR>", "Clean" },
              n = { "<cmd>lua require('bookmarks').bookmark_next()<CR>", "Next Bookmark" },
              p = { "<cmd>lua require('bookmarks').bookmark_prev()<CR>", "Previous Bookmark" },
              l = { "<cmd>lua require('bookmarks').bookmark_list()<CR>", "List Bookmark" },
              x = { "<cmd>lua require('bookmarks').bookmark_clear_all()<CR>", "Clear all" },
            }
          }, opts)
        end
      }
    end
  }
}
