local M = {}

function M.setup()
  local lspconfig = require "lspconfig"
  local lsp_status = require "lsp-status"
  local configCapabilities = require('cmp_nvim_lsp').default_capabilities()

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

  lspconfig.eslint.setup {
    settings = {
      packageManager = 'yarn'
    },
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  }

  lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufrn)
      on_attach(client, bufrn)
    end
  }

  lspconfig.solargraph.setup {
    filetypes = { 'ruby' },
    init_options = {
      formatting = true,
    },
    settings = {
      solargraph = {
        diagnostics = true,     -- Enable diagnostics
      },
    },
    capabilities = capabilities,
    on_attach = function(client)
      on_attach(client, bufrn)
    end,
  }
  lspconfig.rubocop.setup {
    filetypes = { "ruby" },
  }
end

return M
