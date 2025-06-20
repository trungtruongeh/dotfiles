local lspconfigSetup = require("plugins.lsp.nvim_lspconfig").setup
local cmpSetup = require("plugins.lsp.nvim_cmp").setup

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

return {
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  { "onsails/lspkind.nvim" },
  { 'nvim-lua/lsp-status.nvim' },

  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = "BufReadPre",
    config = cmpSetup,
  },

  {
    'neovim/nvim-lspconfig',
    version = false,
    dependencies = { "nvim-lua/lsp-status.nvim" },
    event = "BufReadPre",
    config = lspconfigSetup,
  },

  {
    "pmizio/typescript-tools.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("typescript-tools").setup {
        settings = {
          separate_diagnostic_server = false,
          tsserver_file_preferences = function(ft)
            return {
              includeInlayParameterNameHints = "all",
              includeCompletionsForModuleExports = true,
              quotePreference = "auto",
            }
          end,
          tsserver_format_options = function(ft)
            return {
              allowIncompleteCompletions = false,
              allowRenameOfImportPath = false,
            }
          end
        },
      }

      local whichkey = require "which-key"

      local keymap_c = {
        c = {
          i = { "<cmd>TSToolsAddMissingImports<CR>", "add missing import" },
          I = { "<cmd>TSToolsOrganizeImports<CR>", "organise imports" },
          u = { "<cmd>TSToolsRemoveUnusedImports<CR>", "remove all unsued imports" },
          U = { "<cmd>TSToolsRemoveUnused<CR>", "remove all unsued statements" },
          f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" },
          r = { "<cmd>TSToolsFileReferences<CR>", "reference file" },
          R = { "<cmd>TSToolsRenameFile<CR>", "Rename file" },
        }
      };

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
  },
}
