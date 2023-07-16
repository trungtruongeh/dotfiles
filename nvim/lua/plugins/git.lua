local lazygit = {
  "kdheepak/lazygit.nvim",
  -- optional for floating window border decoration
  dependencies = {
      "nvim-lua/plenary.nvim",
  },
}

local gitSign = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, "Blame Line (Full)")
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
}

local gitLinker = {
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("gitlinker").setup { mappings = nil }
  end,
}

local gitBlameLine = {
  "APZelos/blamer.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gb", "<cmd>BlamerToggle<cr>", desc = "Blamer Toggle" },
  },
}

return { lazygit, gitSign, gitLinker, gitBlameLine }