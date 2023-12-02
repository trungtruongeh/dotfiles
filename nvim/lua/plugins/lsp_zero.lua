local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

local rubocop = {
  lintCommand = "bundle exec rubocop --format emacs --force-exclusion",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %t: %m" },
  formatCommand =
  'bundle exec rubocop --auto-correct --force-exclusion --stdin {} 2>/dev/null | sed "1,/^====================$/d"',
  formatStdin = true,
}

local function setupCmp()
  local cmp = require "cmp"
  local cmp_action = require("lsp-zero").cmp_action()

  require("luasnip.loaders.from_vscode").lazy_load({
    paths = { '/snippets' }
  })

  cmp.setup({
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
  })
end

return {
  --- Uncomment these if you want to manage LSP servers from neovim
  -- {'williamboman/mason.nvim'},
  -- {'williamboman/mason-lspconfig.nvim'},

  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
  { "onsails/lspkind.nvim" },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = "BufEnter",
    dependencies = { "jose-elias-alvarez/typescript.nvim", "nvim-lua/lsp-status.nvim" },
    config = function()
      local lsp_zero = require('lsp-zero').preset {}
      local lsp_status = require "lsp-status"

      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })

        local whichkey = require "which-key"

        local keymap_c = {
          c = {}
        };

        if client.server_capabilities.documentFormattingProvider then
          keymap_c.c.f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" }
        end

        local keymap_g = {
          name = "Goto",
          d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
          p = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Preview Definition" },
          D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
          h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
          i = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
          t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
          r = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
        }

        local o = { buffer = bufnr, prefix = "<leader>" }
        whichkey.register(keymap_c, o)

        o = { buffer = bufnr, prefix = "g" }
        whichkey.register(keymap_g, o)
      end)

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      lsp_zero.setup_servers({ 'lua_ls', 'rust_analyzer' })

      require('lspconfig').tsserver.setup({
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
        end,
      })
      require('lspconfig').eslint.setup({})

      -- require('lspconfig').rubocop.setup({
      --   cmd = { "rubocop", "--format", "emacs", "--force-exclusion" }
      -- })

      require('lspconfig').solargraph.setup({
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentFormattingRangeProvider = false
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

      local lspconfig = require "lspconfig"
      lspconfig.efm.setup {
        root_dir = lspconfig.util.root_pattern(".git", "package.json", "Gemfile"),
        init_options = { documentFormatting = true, codeAction = false },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "ruby", "json", "markdown" },
        settings = {
          languages = {
            javascript = { prettier },
            javascriptreact = { prettier },
            typescript = { prettier },
            typescriptreact = { prettier },
            json = { prettier },
            ruby = { rubocop },
          },
        },

        on_attach = function(client, bufnr)
          client.server_capabilities.definitionProvider = false
          client.server_capabilities.documentFormattingProvider = true
          client.server_capabilities.documentFormattingRangeProvider = true
        end,
        flags = { debounce_text_changes = 150 },
      }

      setupCmp()

      lsp_zero.setup()
    end
  },
  {
    "j-hui/fidget.nvim",
    event = "BufEnter",
    opts = {
      -- options
    },
  }
}
