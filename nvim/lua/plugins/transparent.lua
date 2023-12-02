return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  config = function()
    require("transparent").setup {
      groups = { -- table: default groups
        "Normal",
        "NormalNC",
        "LineNr",
        "EndOfBuffer",
      },
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
      },   -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    }
  end,
}
