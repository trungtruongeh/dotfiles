return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup {
      groups = { -- table: default groups
        "Normal",
        "NormalNC",
        "LineNr",
        "EndOfBuffer",
      },
      extra_groups = {},   -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    }
  end,
}
