-- return {
--   "hrsh7th/nvim-cmp",
--   version = false,
--   event = "BufRead",
--   dependencies = {
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--     "saadparwaiz1/cmp_luasnip",
--     "onsails/lspkind.nvim",
--     'neovim/nvim-lspconfig',
--     'hrsh7th/cmp-cmdline',
--     'L3MON4D3/LuaSnip',
--     'saadparwaiz1/cmp_luasnip',
--     'VonHeikemen/lsp-zero.nvim'
--   },
--   opts = function(_, opts)
--     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
--     local has_words_before = function()
--       unpack = unpack or table.unpack
--       local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--       return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--     end
--
--     local luasnip = require("luasnip")
--     local cmp = require("cmp")
--     local cmp_action = require('lsp-zero').cmp_action()
--     local cmp_format = require('lsp-zero').cmp_format()
--
--     require("luasnip.loaders.from_vscode").lazy_load({
--       paths = { '/snippets' }
--     })
--
--     opts.mapping = vim.tbl_extend("force", opts.mapping, {
--       ["<Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           cmp.select_next_item()
--         elseif luasnip.expand_or_jumpable() then
--           luasnip.expand_or_jump()
--         elseif has_words_before() then
--           cmp.complete()
--         else
--           fallback()
--         end
--       end, { "i", "s" }),
--       ["<S-Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           cmp.select_prev_item()
--         elseif luasnip.jumpable(-1) then
--           luasnip.jump(-1)
--         else
--           fallback()
--         end
--       end, { "i", "s" }),
--       ["<CR>"] = cmp.mapping.confirm { select = false },
--
--     })
--
--     opts.preselect = "item"
--     opts.sources = {
--       { name = "copilot" },
--       { name = "luasnip" },
--       { name = "path" },
--       { name = "nvim_lsp" },
--       { name = "nvim_lua" },
--       { name = "buffer" },
--     }
--     opts.completion = {
--       autocomplete = false,
--       completeopt = "menu,menuone,noinsert",
--     }
--     opts.formatting = vim.tbl_extend("force", opts.formatting, {
--       fields = { "abbr", "kind", "menu" },
--       format = require("lspkind").cmp_format {
--         mode = "symbol",         -- show only symbol annotations
--         maxwidth = 50,           -- prevent the popup from showing more than provided characters
--         ellipsis_char = "...",   -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
--         symbol_map = { Copilot = "" }
--       },
--     })
--     opts.sorting = {
--       priority_weight = 2,
--       comparators = {
--         require("copilot_cmp.comparators").prioritize,
--       },
--     }
--   end,
--   config = function(_, opts)
--     for _, source in ipairs(opts.sources) do
--       source.group_index = source.group_index or 1
--     end
--     require("cmp").setup(opts)
--   end,
-- }
