local M = {}

-- Helper function to check if cursor is after a word
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Helper function to feed terminal keys
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.setup ()
  local cmp = require "cmp"

  cmp.setup {
    preselect = "item",
    sources = cmp.config.sources {
      { name = "copilot", priority = 1 },
      { name = "path", priority = 3 },
      { name = "nvim_lsp", priority = 2 },
      { name = "buffer", priority = 4 },
    },
    completion = {
      autocomplete = false,
      completeopt = "menu,menuone,noinsert",
    },
    mapping = {
      ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
          }) -- Confirm the selected item, or the first if none is selected
        else
          fallback() -- Insert a newline if no completion menu is visible
        end
      end, { 'i', 's' }),

      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ['<C-e>'] = cmp.mapping.abort(),

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
            cmp.complete()
        else
          fallback() -- If nothing else is matched, use fallback
        end
      end, { "i", "s" }), -- Enable in insert and select modes

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = require("lspkind").cmp_format {
        mode = "symbol",       -- show only symbol annotations
        maxwidth = 50,         -- prevent the popup from showing more than provided characters
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
        symbol_map = {
          Copilot = "",
        }
      },
    },
    sorting = {
      priority_weight = 1.0,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        function(entry1, entry2)
          local kind1 = entry1:get_kind()
          local kind2 = entry2:get_kind()
          if kind1 ~= kind2 then
            if kind1 == cmp.lsp.CompletionItemKind.Snippet then
              return false
            end
            if kind2 == cmp.lsp.CompletionItemKind.Snippet then
              return true
            end
          end
        end,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    }
  }


  -- Use completion in command-line mode
  cmp.setup.cmdline('/', {
      sources = {
          { name = 'buffer' }
      }
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
  })
end

return M;
