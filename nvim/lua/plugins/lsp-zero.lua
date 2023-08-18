local eslint = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %trror %m" },
}

local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
}

local rubocop = {
  lintCommand = "rubocop --format emacs --force-exclusion --stdin ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %t: %m" },
  formatCommand = 'rubocop --auto-correct --force-exclusion --stdin ${INPUT} 2>/dev/null | sed "1,/^====================$/d"',
  formatStdin = true,
}

return {
  "nvim-lua/lsp-status.nvim",
  "nvimdev/lspsaga.nvim",
  {
    "jose-elias-alvarez/typescript.nvim",
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { -- Optional
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
    },
    config = function()
      local lsp = require("lsp-zero").preset {}
      local lsp_status = require "lsp-status"
      local saga = require "lspsaga"

      saga.setup {
        lightbulb = {
          enable = false,
        },
        symbol_in_winbar = {
          enable = false,
        },
        ui = {
          -- Gruvbox dark
          colors = {
            normal_bg = "#32302f",
            title_bg = "#32302f",
            fg = "#ebdbb2",
            red = "#cc241d",
            magenta = "#b16286",
            yellow = "#d79921",
            green = "#98971a",
            cyan = "#689d6a",
            blue = "#458588",
            white = "#a89984",
            black = "#282828",
          },
        },
      }

      local common_on_attach = function(client, bufnr)
        lsp_status.on_attach(client)

        lsp.default_keymaps { buffer = bufnr }

        local opts = { noremap = true, silent = true, buffer = true }

        local keymap = vim.keymap.set

        keymap("n", "<leader>ld", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
        keymap("n", "<leader>lv", "<CMD>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
        keymap("n", "<leader>lr", "<CMD>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "<leader>ll", "<CMD>lua vim.diagnostic.setloclist()<CR>", opts)

        keymap("n", "<leader>lh", ":Lspsaga hover_doc<CR>", opts)
        keymap("n", "<leader>ln", ":Lspsaga rename<CR>", opts)
        keymap("n", "<leader>lo", ":Lspsaga outline<CR>", opts)
        keymap("n", "<C-f>", ':lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
        keymap("n", "<C-b>", ':lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

        local whichkey = require "which-key"

        -- Whichkey
        local keymap_l = {
          l = {
            name = "LSP",
            R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
            a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
            d = { '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', "Line Diagnostics" },
            D = { "<cmd>lua require('telescope.builtin').diagnostics()<CR>", "Diagnostics" },
            i = { "<cmd>LspInfo<CR>", "Lsp Info" },
            n = { "<cmd>lua require('renamer').rename()<CR>", "Rename" },
            r = { "<cmd>lua require('telescope.builtin').lsp_references()<CR>", "References" },
            t = { "<cmd>TroubleToggle document_diagnostics<CR>", "Trouble" },
          },
        }
        if client.server_capabilities.documentFormattingProvider then
          keymap_l.l.F = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" }
        end

        local keymap_g = {
          name = "Goto",
          d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
          p = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Definition" },
          D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
          h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
          I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
          b = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
        }

        local keymap_v_l = {
          l = {
            name = "LSP",
            a = { "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
          },
        }

        local o = { buffer = bufnr, prefix = "<leader>" }
        whichkey.register(keymap_l, o)
        -- legendary.bind_whichkey(keymap_l, o, false)

        o = { mode = "v", buffer = bufnr, prefix = "<leader>" }
        whichkey.register(keymap_v_l, o)
        -- legendary.bind_whichkey(keymap_v_l, o, false)

        o = { buffer = bufnr, prefix = "g" }
        whichkey.register(keymap_g, o)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

      lsp.extend_cmp()
      lsp.on_attach(function(client, bufnr)
        common_on_attach(client, bufnr)
        lsp.async_autoformat(client, bufnr)
      end)

      -- (Optional) Configure lua language server for neovim
      local lspconfig = require "lspconfig"
      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
      lspconfig.tsserver.setup {
        on_attach = function(client, bufnr)
          common_on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
      }
      lspconfig.solargraph.setup {
        on_attach = function(client, bufnr)
          common_on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          -- client.server_capabilities.definitionProvider = false
        end,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
      }
      require("typescript").setup {
        server = {
          on_attach = function(client, bufnr)
            common_on_attach(client, bufnr)
            vim.lsp.buf.inlay_hint(bufnr, false)
          end,
          settings = {
            -- specify some or all of the following settings if you want to adjust the default behavior
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

      lspconfig.efm.setup {
        root_dir = lspconfig.util.root_pattern(".git", "package.json"),
        init_options = { documentFormatting = true, codeAction = false },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "ruby", "json", "markdown" },
        settings = {
          languages = {
            javascript = { prettier, eslint },
            javascriptreact = { prettier, eslint },
            typescript = { prettier, eslint },
            typescriptreact = { prettier, eslint },
            json = { prettier },
            ruby = { rubocop },
          },
        },

        on_attach = function(client, bufnr)
          common_on_attach(client, bufnr)
          client.server_capabilities.definitionProvider = false
        end,
        flags = { debounce_text_changes = 150 },
      }
      lsp.setup()
    end,
  },
}
