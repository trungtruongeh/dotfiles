-- vim.opt.termguicolors = true
-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

-- vim.opt.list = true
-- vim.opt.listchars:append "eol:↴"

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
    -- config = function ()
    --   require("indent_blankline").setup {
    --     space_char_blankline = "",
    --     show_current_context = true,
    --     show_current_context_start = true,
    --     char_highlight_list = {
    --       "IndentBlanklineIndent1",
    --       "IndentBlanklineIndent2",
    --       "IndentBlanklineIndent3",
    --       "IndentBlanklineIndent4",
    --       "IndentBlanklineIndent5",
    --       "IndentBlanklineIndent6",
    --     },
    --     show_trailing_blankline_indent = false,
    --   }
    -- end
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    disabled = true,
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  }
}