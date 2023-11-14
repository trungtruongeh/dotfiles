return {
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find "Windows")
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      require("luasnip.loaders.from_vscode").load()
    end,
  },
}
