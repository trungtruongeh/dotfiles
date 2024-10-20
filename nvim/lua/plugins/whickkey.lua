return {
  "folke/which-key.nvim",
  tag = 'v2.1.0',
  config = function()
    local whichkey = require "which-key"
    local utils = require "utils"

    local opts = {
      mode = "n", -- Normal mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    }

    local mappings = {
      ["1"] = { "<cmd>ToggleTerm<CR>", "Open Terminal" },
      ["2"] = { "<cmd>TransparentToggle<CR>", "Toggle background transparent" },
      ["3"] = { "<cmd>NeoAI<CR>", "Toggle ChatGPT" },
      ["w"] = { "<cmd>update!<CR>", "Save" },
      ["q"] = { "<cmd>q!<CR>", "Quit" },

      a = {
        name = "AI",
        t = { "<cmd>NeoAIToggle<CR>", "NeoAI Toggle" },
      },

      b = {
        name = "Buffer",
      },

      c = {
        name = "Code",
        a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      },

      C = {
        name = "Circle CI",
        a = { "<cmd>CCMyPipelines<cr>", "List and open" },
        o = { "<cmd>lua require('utils').openCurrentCIBranch()<cr>", "Open current branch" },
      },

      f = {
        name = "Find",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        h = { "<cmd>Telescope find_files hidden=true<cr>", "Find Hidden File" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        p = { "<cmd>Telescope projects<cr>", "Projects" },
        s = { "<cmd>Telescope grep_string<cr>", "Grep String" },
        r = { "<cmd>Spectre<cr>", "Replace in file" },
      },

      g = {
        name = "Git",
        h = { "GitSigns Hunk" },
        y = {
          "<cmd>lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>",
          "Link",
        },
        z = { "<cmd>lua require('utils.term').git_client_toggle()<CR>", "LazyGit" },
      },
    }

    local function code_keymap()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          vim.schedule(CodeRunner)
        end,
      })

      function CodeRunner()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local fname = vim.fn.expand "%:p:t"
        local keymap_c = {} -- normal key map
        local keymap_c_v = {} -- visual key map

        if ft == "lua" then
          keymap_c = {
            name = "Code",
            r = { "<cmd>luafile %<cr>", "Run" },
          }
        elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
          keymap_c = {
            name = "Code",
            i = { "<cmd>TypescriptAddMissingImports<cr>", "Import Missing" },
            F = { "<cmd>EslintFixAll<cr>", "Fix All Eslint Error" },
            u = { "<cmd>TypescriptRemoveUnused<cr>", "Remove Unused" },
            s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" },
            t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" },
            l = { "<cmd>2TermExec cmd='yarn lint --fix'<cr>", "Yarn lint" },
          }
        elseif ft == "rust" then
          keymap_c = {
            name = "Code",
            r = { "<cmd>2TermExec cmd='cargo run'<cr>", "Cargo run" },  
            b = { "<cmd>2TermExec cmd='cargo build'<cr>", "Cargo build" },  
          }
        end

        if fname == "package.json" then
          keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
          keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
          -- keymap_c.s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" }
          -- keymap_c.t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" }
        end

        if next(keymap_c) ~= nil then
          local k = { c = keymap_c }
          local o = { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
          whichkey.register(k, o)
          -- legendary.bind_whichkey(k, o, false)
        end

        if next(keymap_c_v) ~= nil then
          local k = { c = keymap_c_v }
          local o = { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
          whichkey.register(k, o)
          -- legendary.bind_whichkey(k, o, false)
        end
      end
    end

    whichkey.setup()
    whichkey.register(mappings, opts)

    code_keymap()
  end,
}
