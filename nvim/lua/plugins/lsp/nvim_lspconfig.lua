local M = {}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
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
        R = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
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

  lspconfig.solargraph.setup {
    filetypes = { 'ruby' },
    settings = {
      solargraph = {
        diagnostics = true,     -- Enable diagnostics
        formatting = true,
      },
    },
    capabilities = capabilities,
    on_attach = function(client)
      on_attach(client, bufrn)
    end,
  }

  lspconfig.ruby_lsp.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

  lspconfig.efm.setup {
    root_dir = lspconfig.util.root_pattern("package.json", "Gemfile"),
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
