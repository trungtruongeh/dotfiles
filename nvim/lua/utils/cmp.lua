local M = {}

function M.setup()
  local cmp = require "cmp"
  local cmp_action = require("lsp-zero").cmp_action()

  require("luasnip.loaders.from_vscode").lazy_load({
    paths = { '/snippets' }
  })

  cmp.setup {
    preselect = "item",
    sources = {
      { name = "copilot" },
      { name = "luasnip" },
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer" },
    },
    completion = {
      autocomplete = false,
      completeopt = "menu,menuone,noinsert",
    },
    mapping = {
      ["<CR>"] = cmp.mapping.confirm { select = false },
      ["<C-f>"] = cmp_action.luasnip_jump_forward(),
      ["<C-b>"] = cmp_action.luasnip_jump_backward(),
      ["<Tab>"] = cmp_action.tab_complete(),
      ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = require("lspkind").cmp_format {
        mode = "symbol",       -- show only symbol annotations
        maxwidth = 50,         -- prevent the popup from showing more than provided characters
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
        symbol_map = { Copilot = "" }
      },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
      },
    }
  }
end

return M
