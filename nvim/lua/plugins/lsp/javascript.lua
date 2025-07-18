return {
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
              allowIncompleteCompletions = true,
              allowRenameOfImportPath = true,
              documentFormattingProvider = false,
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
          r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
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
