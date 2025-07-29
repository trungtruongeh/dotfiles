local M = {}

local eslint = {
  lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}", -- unix format failed to report severity
  lintStdin = true,
  lintFormats = { "%f: line %l, col %c, %t%m" },
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true,
  securities = {
    W = 'warning',
    E = 'error',
  }
}

local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
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

function M.setup()
  vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })

  vim.diagnostic.config({
    signs = true,
    underline = true,
    virtual_text = false, -- or configure as you like
    update_in_insert = true,
    severity_sort = true,
  })

  local lspconfig = require "lspconfig"
  local lsp_status = require "lsp-status"
  local configCapabilities = require('cmp_nvim_lsp').default_capabilities()

  require("luasnip.loaders.from_vscode").lazy_load()

  lsp_status.register_progress()

  local capabilities = vim.tbl_extend('keep', configCapabilities or {}, lsp_status.capabilities)

  local on_attach = function(client, bufnr)
    lsp_status.on_attach(client)

    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    local whichkey = require "which-key"

    local keymap_c = {
      c = {
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
      }
    };

    if client.server_capabilities.documentFormattingProvider then
      keymap_c.c.f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" }
    end

    local o = { buffer = bufnr, prefix = "<leader>" }
    whichkey.register(keymap_c, o)

    local keymap_g = {
      name = "Goto",
      d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
      h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
      i = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      r = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
    }

    o = { buffer = bufnr, prefix = "g" }
    whichkey.register(keymap_g, o)
  end

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

  lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  lspconfig.gopls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
      on_attach(client, bufnr)
    end,
    settings = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  }

  lspconfig.solargraph.setup {
    filetypes = { 'ruby' },
    settings = {
      solargraph = {
        diagnostics = true, -- Enable diagnostics
        formatting = true,
      },
    },
    capabilities = capabilities,
    on_attach = function(client)
      on_attach(client, bufrn)
    end,
  }

  -- lspconfig.ruby_lsp.setup {
  --   filetypes = { 'ruby' },
  --   init_options = {
  --     formatter = 'standard',
  --     linters = { 'standard' },
  --   },
  --   settings = {
  --     solargraph = {
  --       diagnostics = true,     -- Enable diagnostics
  --       formatting = true,
  --     },
  --   },
  --   capabilities = capabilities,
  --   on_attach = function(client)
  --     on_attach(client, bufrn)
  --   end,
  -- }

  lspconfig.efm.setup {
    root_dir = lspconfig.util.root_pattern(".git", "package.json", '.eslintrc.js', '.eslintrc.json', "Gemfile"),
    init_options = { documentFormatting = true, codeAction = false },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "ruby", "json", "markdown" },
    settings = {
      languages = {
        ruby = { rubocop },
        javascript = { prettier, eslint },
        javascriptreact = { prettier, eslint },
        ["javascript.jsx"] = { prettier, eslint },
        typescript = { prettier, eslint },
        ["typescript.tsx"] = { prettier, eslint },
        typescriptreact = { prettier, eslint }
      },
    },

    on_attach = function(client, bufnr)
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentFormattingRangeProvider = true
    end,
    flags = { debounce_text_changes = 150 },
  }
end

return M
