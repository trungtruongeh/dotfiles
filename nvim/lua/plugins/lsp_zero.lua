local function setupCmp()
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

return {
--- Uncomment these if you want to manage LSP servers from neovim
-- {'williamboman/mason.nvim'},
-- {'williamboman/mason-lspconfig.nvim'},

{'neovim/nvim-lspconfig'},
{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/nvim-cmp'},
{'L3MON4D3/LuaSnip'},
  {"onsails/lspkind.nvim"},
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = "BufEnter",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})

        local opts = { noremap = true, silent = true, buffer = true }
        local keymap = vim.keymap.set

        keymap("n", "<leader>lr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "<leader>ll", "<CMD>lua vim.diagnostic.setloclist()<CR>", opts)
      end)

      lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

      lsp_zero.setup_servers({'lua_ls', 'rust_analyzer'})

      require('lspconfig').tsserver.setup({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
      })
      require('lspconfig').eslint.setup({})
      require('lspconfig').rubocop.setup({})
      require('lspconfig').solargraph.setup({})

      -- lsp_zero.format_mapping('gq', {
      --   format_opts = {
      --     async = false,
      --     timeout_ms = 10000,
      --   },
      --   servers = {
      --     ['tsserver'] = {'javascript', 'typescript', 'javascriptreact', 'typescriptreact'},
      --     ['eslint'] = {'javascript', 'typescript', 'javascriptreact', 'typescriptreact'},
      --     ['lua_ls'] = {'lua'},
      --     ['rust_analyzer'] = {'rust'},
      --     ['rubocop'] = {'ruby'},
      --     ['solargraph'] = {'ruby'},
      --   }
      -- })
      --

      vim.opt.signcolumn = "yes"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.lsp.start {
      name = "rubocop",
      cmd = { "bundle", "exec", "rubocop", "--lsp" },
    }
  end,
})

      require("typescript").setup {
        server = {
          on_attach = function(client, bufnr)
            vim.lsp.buf.inlay_hint(bufnr, false)
          end,
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
      }




      setupCmp()
    end
  },

}
