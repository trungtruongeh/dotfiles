local M = {}

function M.setup()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugins
  local plugins = {
    { "wbthomason/packer.nvim" },

    -- Performance
    { "lewis6991/impatient.nvim" },

    -- Load only when require
    { "nvim-lua/plenary.nvim", module = "plenary" },

    -- literate programming
    {
      "~/workspace/alpha2phi/lp.nvim",
      enabled = false,
    },

    -- Notification
    {
      "rcarriga/nvim-notify",
      event = "BufReadPre",
      config = function()
        require("config.notify").setup()
      end,
      enabled = true,
    },
    {
      "simrat39/desktop-notify.nvim",
      config = function()
        require("desktop-notify").override_vim_notify()
      end,
      enabled = false,
    },
    {
      "vigoux/notifier.nvim",
      config = function()
        require("notifier").setup {}
      end,
      enabled = false,
    },

    -- Colorscheme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
        require("catppuccin").setup()
        vim.cmd [[colorscheme catppuccin]]
      end,
      enabled = false,
    },

    {
      "folke/tokyonight.nvim",
      config = function()
        vim.cmd.colorscheme [[tokyonight]]
      end,
      enabled = false,
    },
    {
      "sainnhe/everforest",
      config = function()
        vim.g.everforest_better_performance = 1
        vim.cmd.colorscheme [[everforest]]
      end,
      enabled = true,
    },
    {
      "projekt0n/github-nvim-theme",
      enabled = false,
    },
    {
      "sainnhe/gruvbox-material",
      config = function()
        vim.cmd "colorscheme gruvbox-material"
      end,
      enabled = false,
    },
    {
      "arcticicestudio/nord-vim",
      config = function()
        vim.cmd "colorscheme nord"
      end,
      enabled = false,
    },
    {
      "nvchad/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
        require("colorizer").setup {}
      end,
    },
    {
      "rktjmp/lush.nvim",
      cmd = { "LushRunQuickstart", "LushRunTutorial", "Lushify", "LushImport" },
      enabled = true,
    },
    {
      "max397574/colortils.nvim",
      cmd = "Colortils",
      config = function()
        require("colortils").setup()
      end,
    },
    {
      "ziontee113/color-picker.nvim",
      cmd = { "PickColor", "PickColorInsert" },
      config = function()
        require "color-picker"
      end,
    },
    {
      "lifepillar/vim-colortemplate",
      enabled = false,
    },

    -- Startup screen
    {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    },
    {
      "folke/drop.nvim",
      event = "VimEnter",
      config = function()
        math.randomseed(os.time())
        local theme = ({ "stars", "snow", "xmas" })[math.random(1, 3)]
        require("drop").setup { theme = theme }
      end,
      enabled = false,
    },

    -- Doc
    { "nanotee/luv-vimdocs", event = "BufReadPre" },
    { "milisims/nvim-luaref", event = "BufReadPre" },

    -- Better Netrw
    { "tpope/vim-vinegar", event = "BufReadPre" },

    -- Git
    {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("config.neogit").setup()
      end,
    },
    { "jreybert/vimagit", cmd = "Magit", enabled = false },
    {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns").setup()
      end,
    },
    {
      "tpope/vim-fugitive",
      lazy = true,
      cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
      dependencies = {
        "tpope/vim-rhubarb",
        "idanarye/vim-merginal",
        --[[ "rhysd/committia.vim", ]]
      },
    },
    {
      "rbong/vim-flog",
      cmd = { "Flog", "Flogsplit", "Floggit" },
      wants = { "vim-fugitive" },
    },
    {
      "ruifm/gitlinker.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("gitlinker").setup { mappings = nil }
      end,
    },
    {
      "pwntester/octo.nvim",
      cmd = "Octo",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("octo").setup()
      end,
      enabled = true,
    },
    {
      "akinsho/git-conflict.nvim",
      cmd = {
        "GitConflictChooseTheirs",
        "GitConflictChooseOurs",
        "GitConflictChooseBoth",
        "GitConflictChooseNone",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
        "GitConflictListQf",
      },
      config = function()
        require("git-conflict").setup {}
      end,
    },
    {
      "ldelossa/gh.nvim",
      lazy = true,
      dependencies = { { "ldelossa/litee.nvim" } },
      event = "BufReadPre",
      cmd = { "GHOpenPR" },
      config = function()
        require("litee.lib").setup()
        require("litee.gh").setup()
      end,
      enabled = false,
    },
    { "f-person/git-blame.nvim", cmd = { "GitBlameToggle" } },
    {
      "tanvirtin/vgit.nvim",
      config = function()
        require("vgit").setup()
      end,
      cmd = { "VGit" },
    },
    { "knsh14/vim-github-link", cmd = { "GetCommitLink", "GetCurrentBranchLink", "GetCurrentCommitLink" } },
    { "segeljakt/vim-silicon", cmd = { "Silicon" } },
    {
      "mattn/vim-gist",
      lazy = true,
      dependencies = { "mattn/webapi-vim" },
      cmd = { "Gist" },
      config = function()
        vim.g.gist_open_browser_after_post = 1
      end,
    },

    -- WhichKey
    {
      "folke/which-key.nvim",
      event = "VimEnter",
      -- keys = { [[<leader>]] },
      config = function()
        require("config.whichkey").setup()
      end,
      enabled = true,
    },

    -- IndentLine
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    },

    -- Better icons
    {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    },

    -- Better Comment
    {
      "numToStr/Comment.nvim",
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("config.comment").setup()
      end,
      enabled = true,
    },
    { "tpope/vim-commentary", keys = { "gc", "gcc", "gbc" }, enabled = false },

    -- Better surround
    { "tpope/vim-surround", event = "BufReadPre" },
    {
      "Matt-A-Bennett/vim-surround-funk",
      event = "BufReadPre",
      config = function()
        require("config.surroundfunk").setup()
      end,
      enabled = false,
    },

    -- Motions
    { "andymass/vim-matchup", event = "CursorMoved" },
    { "wellle/targets.vim", event = "CursorMoved", enabled = true },
    {
      "unblevable/quick-scope",
      keys = { "F", "f", "T", "t" },
      -- config = function()
      --   vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" },
      -- end,
      enabled = true,
    },
    {
      "jinh0/eyeliner.nvim",
      keys = { "F", "f", "T", "t" },
      config = function()
        require("eyeliner").setup {
          highlight_on_key = true,
        }
      end,
      enabled = false,
    },
    { "chaoren/vim-wordmotion", lazy = true, fn = { "<Plug>WordMotion_w" } },

    -- Buffer
    { "kazhala/close-buffers.nvim", cmd = { "BDelete", "BWipeout" } },
    {
      "matbme/JABS.nvim",
      cmd = "JABSOpen",
      config = function()
        require("config.jabs").setup()
      end,
      enabled = true,
    },
    {
      "chentoast/marks.nvim",
      event = "BufReadPre",
      config = function()
        require("marks").setup {}
      end,
    },

    -- IDE
    {
      "max397574/better-escape.nvim",
      event = { "InsertEnter" },
      config = function()
        require("better_escape").setup {
          mapping = { "jk" },
          timeout = vim.o.timeoutlen,
          keys = "<ESC>",
        }
      end,
    },
    {
      "karb94/neoscroll.nvim",
      event = "BufReadPre",
      config = function()
        require("config.neoscroll").setup()
      end,
      enabled = false,
    },
    { "google/vim-searchindex", event = "BufReadPre" },
    { "tyru/open-browser.vim", event = "BufReadPre" },
    {
      "bennypowers/nvim-regexplainer",
      config = function()
        require("regexplainer").setup()
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "MunifTanjim/nui.nvim",
      },
      enabled = false,
    },
    {
      "Djancyp/regex.nvim",
      config = function()
        require("regex-nvim").Setup()
      end,
      enabled = false,
    },
    { "mbbill/undotree", cmd = { "UndotreeToggle" } },
    {
      "anuvyklack/windows.nvim",
      dependencies = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim",
      },
      cmd = { "WindowsToggleAutowidth", "WindowsMaximize" },
      config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require("windows").setup()
      end,
      enabled = false,
    },
    {
      "beauwilliams/focus.nvim",
      cmd = { "FocusToggle", "FocusMaxOrEqual" },
      config = function()
        require("focus").setup { hybridnumber = true }
      end,
      enabled = false,
    },
    {
      "smjonas/live-command.nvim",
      event = { "BufReadPre" },
      config = function()
        require("live-command").setup {
          commands = {
            Norm = { cmd = "norm" },
            Reg = {
              cmd = "norm",
              args = function(opts)
                return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
              end,
              range = "",
            },
          },
        }
      end,
      enabled = false,
    },
    {
      "echasnovski/mini.nvim",
      event = { "BufReadPre" },
      config = function()
        require("config.mini").setup()
      end,
    },
    { "MunifTanjim/nui.nvim", enabled = false },
    {
      "folke/noice.nvim",
      event = { "VimEnter" },
      config = function()
        require("config.noice").setup()
      end,
      enabled = false,
    },

    -- Code documentation
    {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      enabled = true,
    },

    {
      "kkoomen/vim-doge",
      build = ":call doge#install()",
      config = function()
        require("config.doge").setup()
      end,
      cmd = { "DogeGenerate", "DogeCreateDocStandard" },
      enabled = true,
    },

    -- Jumps
    {
      "phaazon/hop.nvim",
      cmd = "HopWord",
      keys = { "f", "F", "t", "T" },
      config = function()
        require("config.hop").setup()
      end,
      enabled = false,
    },
    {
      "ggandor/flit.nvim",
      keys = { "f", "F", "t", "T" },
      config = function()
        require("flit").setup()
      end,
      dependencies = { "ggandor/leap.nvim" },
      enabled = false,
    },
    {
      "ggandor/leap.nvim",
      keys = { "s", "S" },
      config = function()
        local leap = require "leap"
        leap.add_default_mappings()
      end,
      enabled = true,
    },
    {
      "abecodes/tabout.nvim",
      after = { "nvim-cmp" },
      config = function()
        require("tabout").setup {
          completion = false,
          ignore_beginning = true,
        }
      end,
    },
    { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" }, enabled = true },
    -- {
    --   "ggandor/lightspeed.nvim",
    --   keys = { "s", "S", "f", "F", "t", "T" },
    --   config = function()
    --     require("lightspeed").setup {}
    --   end,
    -- },

    -- Markdown
    {
      "iamcco/markdown-preview.nvim",
      lazy = true,
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
      dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
    },
    {
      "jakewvincent/mkdnflow.nvim",
      config = function()
        require("mkdnflow").setup {}
      end,
      ft = "markdown",
    },
    {
      "nvim-neorg/neorg",
      config = function()
        require("neorg").setup {
          load = {
            ["core.defaults"] = {},
            ["core.presenter"] = {
              config = {
                zen_mode = "truezen",
              },
            },
          },
        }
      end,
      ft = "norg",
      dependencies = { "nvim-lua/plenary.nvim", "Pocco81/TrueZen.nvim" },
      enabled = false,
    },
    {
      "phaazon/mind.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("mind").setup()
      end,
      enabled = false,
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      event = "BufReadPre",
      config = function()
        require("config.lualine").setup()
      end,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
        { "windwp/nvim-ts-autotag", event = "InsertEnter" },
        { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPre" },
        { "p00f/nvim-ts-rainbow", event = "BufReadPre", enabled = false },
        { "RRethy/nvim-treesitter-textsubjects", event = "BufReadPre" },
        { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle" } },
        -- {
        --   "lewis6991/spellsitter.nvim",
        --   config = function()
        --     require("spellsitter").setup()
        --   end,
        -- },
        { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPre", enabled = false },
        { "mfussenegger/nvim-treehopper", enabled = false },
        {
          "m-demare/hlargs.nvim",
          config = function()
            require("config.hlargs").setup()
          end,
          enabled = true,
        },
        {
          "AckslD/nvim-FeMaco.lua",
          config = function()
            require("femaco").setup()
          end,
          ft = { "markdown" },
          cmd = { "Femaco" },
          enabled = false,
        },
        -- { "yioneko/nvim-yati", event = "BufReadPre" },
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      event = { "VimEnter" },
      config = function()
        require("config.telescope").setup()
      end,
      dependencies = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
        },
        { "nvim-telescope/telescope-project.nvim" },
        { "cljoly/telescope-repo.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        {
          "nvim-telescope/telescope-frecency.nvim",
          dependencies = "tami5/sqlite.lua",
        },
        {
          "ahmedkhalf/project.nvim",
          config = function()
            require("config.project").setup()
          end,
        },
        { "nvim-telescope/telescope-dap.nvim" },
        {
          "AckslD/nvim-neoclip.lua",
          dependencies = {
            { "tami5/sqlite.lua" },
          },
        },
        { "nvim-telescope/telescope-smart-history.nvim" },
        {
          "alpha2phi/telescope-arecibo.nvim",
          rocks = { "openssl", "lua-http-parser" },
        },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "dhruvmanila/telescope-bookmarks.nvim" },
        { "nvim-telescope/telescope-github.nvim" },
        { "jvgrootveld/telescope-zoxide" },
        { "Zane-/cder.nvim" },
        "nvim-telescope/telescope-symbols.nvim",
        -- "nvim-telescope/telescope-ui-select.nvim",
      },
    },

    -- nvim-tree
    {
      "nvim-tree/nvim-tree.lua",
      lazy = true,
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("config.nvimtree").setup()
      end,
    },
    { "elihunter173/dirbuf.nvim", cmd = { "Dirbuf" } },

    -- Buffer line
    {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      config = function()
        require("config.bufferline").setup()
      end,
    },

    -- User interface
    {
      "stevearc/dressing.nvim",
      event = "BufReadPre",
      config = function()
        require("dressing").setup {
          input = { relative = "editor" },
          select = {
            backend = { "telescope", "fzf", "builtin" },
          },
        }
      end,
      enabled = true,
    },
    {
      "ray-x/guihua.lua",
      build = "cd lua/fzy && make",
      enabled = false,
    },
    {
      "doums/suit.nvim",
      config = function()
        require("suit").setup {}
      end,
      enabled = false,
    },

    -- Completion
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      lazy = true,
      config = function()
        require("config.cmp").setup()
      end,
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        { "hrsh7th/cmp-nvim-lsp" },
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "lukas-reineke/cmp-rg",
        "davidsierradz/cmp-conventionalcommits",
        { "onsails/lspkind-nvim" },
        -- "hrsh7th/cmp-calc",
        -- "f3fora/cmp-spell",
        -- "hrsh7th/cmp-emoji",
        {
          "L3MON4D3/LuaSnip",
          config = function()
            require("config.snip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
        { "tzachar/cmp-tabnine", build = "./install.sh", enabled = false },
      },
    },

    -- Auto pairs
    {
      "windwp/nvim-autopairs",
      lazy = true,
      event = "InsertEnter",
      config = function()
        require("config.autopairs").setup()
      end,
    },

    -- Auto tag
    {
      "windwp/nvim-ts-autotag",
      lazy = true,
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    },

    -- End wise
    {
      "RRethy/nvim-treesitter-endwise",
      lazy = true,
      event = "InsertEnter",
      enabled = true,
    },

    -- LSP
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("config.lsp").setup()
      end,
      dependencies = {
        -- { "lvimuser/lsp-inlayhints.nvim", branch = "readme" },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "jay-babu/mason-null-ls.nvim" },
        "folke/neodev.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
        {
          "j-hui/fidget.nvim",
          config = function()
            require("fidget").setup {}
          end,
        },
        { "b0o/schemastore.nvim", module = { "schemastore" } },
        { "jose-elias-alvarez/typescript.nvim" },
        {
          "SmiteshP/nvim-navic",
          -- "alpha2phi/nvim-navic",
          config = function()
            require("nvim-navic").setup {}
          end,
          module = { "nvim-navic" },
        },
        {
          "simrat39/inlay-hints.nvim",
          config = function()
            require("inlay-hints").setup()
          end,
        },
        {
          "zbirenbaum/neodim",
          event = "LspAttach",
          config = function()
            require("config.neodim").setup()
          end,
          enabled = false,
        },
        {
          "theHamsta/nvim-semantic-tokens",
          config = function()
            require("config.semantictokens").setup()
          end,
          enabled = false,
        },
        {
          "David-Kunz/markid",
          enabled = false,
        },
        {
          "simrat39/symbols-outline.nvim",
          cmd = { "SymbolsOutline" },
          config = function()
            require("symbols-outline").setup()
          end,
          enabled = false,
        },
        -- {
        --   "weilbith/nvim-code-action-menu",
        --   cmd = "CodeActionMenu",
        -- },
        -- {
        --   "rmagatti/goto-preview",
        --   config = function()
        --     require("goto-preview").setup {}
        --   end,
        -- },
        -- {
        --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        --   config = function()
        --     require("lsp_lines").setup()
        --   end,
        -- },
      },
    },

    -- trouble.nvim
    {
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      module = { "trouble.providers.telescope" },
      config = function()
        require("trouble").setup {
          use_diagnostic_signs = true,
        }
      end,
    },

    -- lspsaga.nvim
    {
      "glepnir/lspsaga.nvim",
      cmd = { "Lspsaga" },
      config = function()
        require("config.lspsaga").setup()
      end,
    },

    -- renamer.nvim
    {
      "filipdutescu/renamer.nvim",
      module = { "renamer" },
      config = function()
        require("renamer").setup {}
      end,
    },

    -- Rust
    {
      "simrat39/rust-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
      lazy = true,
      module = "rust-tools",
      ft = { "rust" },
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup {
          null_ls = {
            enabled = true,
            name = "crates.nvim",
          },
        }
      end,
      enabled = true,
    },

    -- Go
    {
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("go").setup()
      end,
      enabled = false,
    },

    -- Java
    { "mfussenegger/nvim-jdtls", ft = { "java" } },

    -- Flutter
    {
      "akinsho/flutter-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.flutter").setup()
      end,
      enabled = false,
    },

    -- Kotlin
    { "udalov/kotlin-vim", ft = { "kotlin" }, enabled = false },

    -- Terminal
    {
      "akinsho/toggleterm.nvim",
      keys = { [[<C-\>]] },
      cmd = { "ToggleTerm", "TermExec" },
      module = { "toggleterm", "toggleterm.terminal" },
      config = function()
        require("config.toggleterm").setup()
      end,
    },

    -- Debugging
    {
      "mfussenegger/nvim-dap",
      lazy = true,
      module = { "dap" },
      dependencies = {
        { "theHamsta/nvim-dap-virtual-text", module = { "nvim-dap-virtual-text" } },
        { "rcarriga/nvim-dap-ui", module = { "dapui" } },
        { "mfussenegger/nvim-dap-python", module = { "dap-python" } },
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go", module = "dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        { "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
        {
          "microsoft/vscode-js-debug",
          lazy = true,
          build = "npm install --legacy-peer-deps && npm run compile",
          enabled = true,
        },
      },
      config = function()
        require("config.dap").setup()
      end,
      enabled = true,
    },

    -- vimspector
    {
      "puremourning/vimspector",
      cmd = { "VimspectorInstall", "VimspectorUpdate" },
      fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
      config = function()
        require("config.vimspector").setup()
      end,
      enabled = false,
    },

    -- Test
    {
      "nvim-neotest/neotest",
      dependencies = {
        {
          "vim-test/vim-test",
          event = { "BufReadPre" },
          config = function()
            require("config.test").setup()
          end,
        },
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "nvim-neotest/neotest-vim-test", module = { "neotest-vim-test" } },
        { "nvim-neotest/neotest-python", module = { "neotest-python" } },
        { "nvim-neotest/neotest-plenary", module = { "neotest-plenary" } },
        { "nvim-neotest/neotest-go", module = { "neotest-go" } },
        { "haydenmeade/neotest-jest", module = { "neotest-jest" } },
        { "rouge8/neotest-rust", module = { "neotest-rust" } },
      },
      module = { "neotest", "neotest.async" },
      config = function()
        require("config.neotest").setup()
      end,
      enabled = true,
    },
    { "diepm/vim-rest-console", ft = { "rest" }, enabled = true },
    {
      "NTBBloodbath/rest.nvim",
      config = function()
        require("rest-nvim").setup {}
        vim.keymap.set("n", "<C-j>", "<Plug>RestNvim", { noremap = true, silent = true })
      end,
      enabled = false,
    },

    -- AI completion
    { "github/copilot.vim", event = "InsertEnter", enabled = false },

    -- Legendary
    {
      "mrjones2014/legendary.nvim",
      lazy = true,
      keys = { [[<C-p>]] },
      module = { "legendary" },
      cmd = { "Legendary" },
      config = function()
        require("config.legendary").setup()
      end,
    },

    -- Harpoon
    {
      "ThePrimeagen/harpoon",
      module = {
        "harpoon",
        "harpoon.cmd-ui",
        "harpoon.mark",
        "harpoon.ui",
        "harpoon.term",
        "telescope._extensions.harpoon",
      },
      config = function()
        require("config.harpoon").setup()
      end,
    },

    -- Refactoring
    {
      "ThePrimeagen/refactoring.nvim",
      module = { "refactoring", "telescope" },
      keys = { [[<leader>r]] },
      config = function()
        require("config.refactoring").setup()
      end,
    },
    { "python-rope/ropevim", build = "pip install ropevim", enabled = false },
    {
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      enabled = true,
      config = function()
        require("bqf").setup()
      end,
    },
    { "kevinhwang91/nvim-hlslens", event = "BufReadPre", enabled = false },
    { "nvim-pack/nvim-spectre", module = "spectre", keys = { "<leader>s" } },
    {
      "https://gitlab.com/yorickpeterse/nvim-pqf",
      event = "BufReadPre",
      config = function()
        require("pqf").setup()
      end,
    },
    {
      "andrewferrier/debugprint.nvim",
      module = { "debugprint" },
      keys = { "g?p", "g?P", "g?v", "g?V", "g?o", "g?O" },
      cmd = { "DeleteDebugPrints" },
      config = function()
        require("debugprint").setup()
      end,
    },

    -- Code folding
    {
      "kevinhwang91/nvim-ufo",
      lazy = true,
      keys = { "zc", "zo", "zR", "zm" },
      wants = { "promise-async" },
      dependencies = "kevinhwang91/promise-async",
      config = function()
        require("ufo").setup {
          provider_selector = function(_, _)
            return { "lsp", "treesitter", "indent" }
          end,
        }
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      end,
      enabled = false,
    },

    -- Performance
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    {
      "nathom/filetype.nvim",
      cond = function()
        return vim.fn.has "nvim-0.8.0" == 0
      end,
    },

    -- Web
    {
      "vuki656/package-info.nvim",
      lazy = true,
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      module = { "package-info" },
      ft = { "json" },
      config = function()
        require("config.package").setup()
      end,
      enabled = true,
    },
    {
      "meain/vim-package-info",
      ft = { "json" },
      build = "npm install",
      enabled = false,
    },

    -- Session
    {
      "rmagatti/auto-session",
      lazy = true,
      cmd = { "SaveSession", "RestoreSession" },
      dependencies = { "rmagatti/session-lens" },
      config = function()
        require("auto-session").setup()
      end,
      enabled = false,
    },
    {
      "jedrzejboczar/possession.nvim",
      config = function()
        require("config.possession").setup()
      end,
      cmd = { "PossessionSave", "PosessionLoad", "PosessionShow", "PossessionList" },
      enabled = false,
    },
    {
      "tpope/vim-obsession",
      cmd = { "Obsess" },
      config = function()
        require("config.obsession").setup()
      end,
      enabled = false,
    },

    -- Practice
    {
      "antonk52/bad-practices.nvim",
      event = "BufReadPre",
      config = function()
        require("bad_practices").setup()
      end,
      enabled = false,
    },

    -- Plugin
    {
      "tpope/vim-scriptease",
      cmd = {
        "Messages", --view messages in quickfix list
        "Verbose", -- view verbose output in preview window.
        "Time", -- measure how long it takes to run some stuff.
      },
      event = "BufReadPre",
    },

    -- Quickfix
    { "romainl/vim-qf", event = "BufReadPre", enabled = false },

    -- Todo
    {
      "folke/todo-comments.nvim",
      config = function()
        require("config.todocomments").setup()
      end,
      cmd = { "TodoQuickfix", "TodoTrouble", "TodoTelescope" },
    },

    -- Diffview
    {
      "sindrets/diffview.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    },

    -- Sidebar
    {
      "liuchengxu/vista.vim",
      cmd = { "Vista" },
      config = function()
        vim.g.vista_default_executive = "nvim_lsp"
      end,
      enabled = false,
    },
    {
      "sidebar-nvim/sidebar.nvim",
      cmd = { "SidebarNvimToggle" },
      config = function()
        require("sidebar-nvim").setup { open = false }
      end,
    },
    {
      "stevearc/aerial.nvim",
      config = function()
        require("aerial").setup {
          backends = { "treesitter", "lsp" },
          on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
            vim.keymap.set("n", "},", "<cmd>AerialNext<CR>", { buffer = bufnr })
          end,
        }
      end,
      module = { "aerial", "telescope._extensions.aerial" },
      cmd = { "AerialToggle" },
    },

    -- Translation
    {
      "voldikss/vim-translator",
      cmd = { "Translate", "TranslateV", "TranslateW", "TranslateWV", "TranslateR", "TranslateRV", "TranslateX" },
      config = function()
        vim.g.translator_target_lang = "zh"
        vim.g.translator_history_enable = true
      end,
    },
    {
      "potamides/pantran.nvim",
      cmd = "Pantran",
    },

    -- REPL
    {
      "hkupty/iron.nvim",
      config = function()
        require("config.iron").setup()
      end,
      enabled = false,
    },

    -- Task runner
    {
      "stevearc/overseer.nvim",
      lazy = true,
      module = { "neotest.consumers.overseer" },
      cmd = {
        "OverseerToggle",
        "OverseerOpen",
        "OverseerRun",
        "OverseerBuild",
        "OverseerClose",
        "OverseerLoadBundle",
        "OverseerSaveBundle",
        "OverseerDeleteBundle",
        "OverseerRunCmd",
        "OverseerQuickAction",
        "OverseerTaskAction",
      },
      config = function()
        require("overseer").setup()
      end,
    },
    {
      "michaelb/sniprun",
      build = "bash ./install.sh",
      cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipReplMemoryClean", "SnipClose", "SnipLive" },
      module = { "sniprun", "sniprun.api" },
    },

    -- Database
    {
      "tpope/vim-dadbod",
      lazy = true,
      dependencies = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
        --[[ "abenz1267/nvim-databasehelper", ]]
      },
      config = function()
        require("config.dadbod").setup()
      end,
      cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    },
    {
      "nanotee/sqls.nvim",
      module = { "sqls" },
      cmd = {
        "SqlsExecuteQuery",
        "SqlsExecuteQueryVertical",
        "SqlsShowDatabases",
        "SqlsShowSchemas",
        "SqlsShowConnections",
        "SqlsSwitchDatabase",
        "SqlsSwitchConnection",
      },
    },
    {
      "dinhhuy258/vim-database",
      build = ":UpdateRemotePlugins",
      cmd = { "VDToggleDatabase", "VDToggleQuery", "VimDatabaseListTablesFzf" },
    },

    -- Testing
    {
      "linty-org/readline.nvim",
      event = { "BufReadPre" },
      config = function()
        require("config.readline").setup()
      end,
    },
    {
      "protex/better-digraphs.nvim",
      config = function()
        require("config.digraph").setup()
      end,
      keys = { "r<C-k><C-k>" },
      enabled = false,
    },
    {
      "ziontee113/icon-picker.nvim",
      config = function()
        require("icon-picker").setup {
          disable_legacy_commands = true,
        }
      end,
      cmd = { "IconPickerNormal", "IconPickerYank", "IconPickerInsert" },
      enabled = true,
    },

    -- {
    --   "dgrbrady/nvim-docker",
    --   dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    --   rocks = "4O4/reactivex",
    --   module = { "nvim-docker" },
    --   enabled = false,
    -- },

    {
      "m-demare/attempt.nvim",
      lazy = true,
      dependencies = "nvim-lua/plenary.nvim",
      module = { "attempt" },
      config = function()
        require("config.attempt").setup()
      end,
      enabled = true,
    },
    {
      "gbprod/substitute.nvim",
      event = "BufReadPre",
      config = function()
        require("config.substitute").setup()
      end,
      enabled = false,
    },
    {
      "AckslD/nvim-trevJ.lua",
      config = function()
        require("trevj").setup()
      end,
      module = "trevj",
      setup = function()
        vim.keymap.set("n", ",j", function()
          require("trevj").format_at_cursor()
        end)
      end,
      enabled = false,
    },
    {
      "narutoxy/dim.lua",
      dependencies = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
      config = function()
        require("dim").setup {
          disable_lsp_decorations = true,
        }
      end,
      enabled = false,
    },
    {
      "linty-org/key-menu.nvim",
      config = function()
        require("config.keymenu").setup()
      end,
      event = "VimEnter",
      enabled = false,
    },
    { "mg979/vim-visual-multi", event = "BufReadPre", enabled = true },
    {
      "anuvyklack/hydra.nvim",
      config = function()
        require("config.hydra").setup()
      end,
      dependencies = "anuvyklack/keymap-layer.nvim",
      module = { "hydra" },
      event = { "BufReadPre" },
      enabled = false,
    },
    {
      "Olical/conjure",
      cmd = { "ConjureSchool" },
      config = function()
        vim.g["conjure#extract#tree_sitter#enabled"] = true
      end,
      enabled = false,
    },

    -- Disabled
    {
      "ziontee113/syntax-tree-surfer",
      lazy = true,
      event = "BufReadPre",
      module = { "syntax-tree-surfer" },
      config = function()
        require("config.syntaxtreesurfer").setup()
      end,
      enabled = false,
    },
    {
      "ghillb/cybu.nvim",
      event = "BufReadPre",
      config = function()
        require("config.cybu").setup()
      end,
      enabled = false,
    },
    { "tversteeg/registers.nvim", enabled = false },
    {
      "TaDaa/vimade",
      cmd = { "VimadeToggle", "VimadeEnable", "VimadeDisable" },
      enabled = false,
      config = function()
        vim.g.vimade.fadelevel = 0.7
        vim.g.vimade.enablesigns = 1
      end,
    },
    {
      "AckslD/nvim-gfold.lua",
      config = function()
        require("gfold").setup()
      end,
      enabled = false,
    },
    {
      "epwalsh/obsidian.nvim",
      enabled = false,
      config = function()
        require("obsidian").setup {
          dir = "~/my-notes",
          completion = {
            nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
          },
        }
      end,
    },

    -- https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
    -- https://github.com/rbong/vim-buffest
    -- https://github.com/jamestthompson3/nvim-remote-containers
    -- https://github.com/esensar/nvim-dev-container
    -- https://github.com/mrjones2014/smart-splits.nvim
    -- https://github.com/ziontee113/icon-picker.nvim
    -- https://github.com/rktjmp/lush.nvim
    -- https://github.com/charludo/projectmgr.nvim
    -- https://github.com/katawful/kreative
    -- https://github.com/kevinhwang91/nvim-ufo
  }

  -- Init and start packer
  local lazy = require "lazy"

  -- Performance
  pcall(require, "impatient")
  -- pcall(require, "packer_compiled")

  lazy.setup(plugins)
end

return M
