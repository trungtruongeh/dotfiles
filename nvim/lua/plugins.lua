local M = {}

function M.setup()
  -- Indicate first time installation
  -- local packer_bootstrap = false

  -- packer.nvim configuration
  -- local conf = {
  --   profile = {
  --     enable = true,
  --     threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  --   },

  --   display = {
  --     open_fn = function()
  --       return require("packer.util").float { border = "rounded" }
  --     end,
  --   },
  -- }

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugins
  local plugins = {
    { "wbthomason/packer.nvim" },

    -- load only when require
    { "nvim-lua/plenary.nvim" },

    -- notification
    {
      "rcarriga/nvim-notify",
      event = "vimenter",
      config = function()
        vim.notify = require "notify"
      end,
    },

    -- colorscheme
    {
      "sainnhe/everforest",
      config = function()
        vim.cmd "colorscheme everforest"
      end,
    },

    -- startup screen
    {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    },

    -- better netrw
    { "tpope/vim-vinegar" },

    -- git
    {
      "TimUntersberger/neogit",
      config = function()
        require("config.neogit").setup()
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      config = function()
        require("config.gitsigns").setup()
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
      "tpope/vim-fugitive",
      dependencies = { "tpope/vim-rhubarb", "idanarye/vim-merginal" },
    },
    {
      "ruifm/gitlinker.nvim",
      config = function()
        require("gitlinker").setup { mappings = nil }
      end,
      dependencies = {
        "nvim-lua/plenary.nvim"
      }
    },
    {
      "pwntester/octo.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("octo").setup()
      end,
    },
    {
      "akinsho/git-conflict.nvim",
      config = function()
        require("git-conflict").setup()
      end,
    },
    { "f-person/git-blame.nvim" },
    {
      "tanvirtin/vgit.nvim",
      config = function()
        require("vgit").setup()
      end,
    },
    { "knsh14/vim-github-link" },
    { "segeljakt/vim-silicon" },
    { "mattn/vim-gist", lazy = true, dependencies = { "mattn/webapi-vim" } },

    -- whichkey
    {
      "folke/which-key.nvim",
      event = "vimenter",
      config = function()
        require("config.whichkey").setup()
      end,
    },

    -- indentline
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "bufreadpre",
      config = function()
        require("config.indentblankline").setup()
      end,
    },

    -- better icons
    {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    },

    -- better comment
    { "numtostr/comment.nvim" },

    -- better surround
    { "tpope/vim-surround", event = "insertenter" },

    -- motions
    { "andymass/vim-matchup", event = "cursormoved" },
    { "wellle/targets.vim", event = "cursormoved" },
    { "unblevable/quick-scope", event = "cursormoved" },
    { "chaoren/vim-wordmotion", lazy = true, fn = { "<plug>wordmotion_w" } },

    {
      "phaazon/hop.nvim",
      cmd = { "hopword", "hopchar1" },
      config = function()
        require("hop").setup {}
      end,
      enabled = false,
    },
    {
      "ggandor/lightspeed.nvim",
      keys = { "s", "s", "f", "f", "t", "t" },
      config = function()
        require("lightspeed").setup {}
      end,
    },

    -- markdown
    {
      "iamcco/markdown-preview.nvim",
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    },

    -- status line
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("config.lualine").setup()
      end,
      dependencies = {
        "kyazdani42/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
      }
    },
    {
      "smiteshp/nvim-gps",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter",
      },
      config = function()
        require("nvim-gps").setup()
      end,
    },

    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      event = "bufread",
      build = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    },

    -- fzf lua
    {
      "ibhagwan/fzf-lua",
      event = "bufenter",
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },

    -- nvim-tree
    {
      "kyazdani42/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("config.nvimtree").setup()
      end,
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },

    -- buffer line
    {
      "akinsho/nvim-bufferline.lua",
      event = "bufreadpre",
      config = function()
        require("config.bufferline").setup()
      end,
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },

    -- user interface
    {
      "stevearc/dressing.nvim",
      event = "bufenter",
      config = function()
        require("dressing").setup {
          select = {
            backend = { "telescope", "fzf", "builtin" },
          },
        }
      end,
      enabled = false,
    },
    { "nvim-telescope/telescope.nvim", name = "telescope" },

    -- completion
    {
      "hrsh7th/nvim-cmp",
      event = "bufreadpre",
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
        -- "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-calc",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-emoji",
        {
          "l3mon4d3/luasnip",
          config = function()
            require("config.luasnip").setup()
          end,
          dependencies = {
            "rafamadriz/friendly-snippets",
          },
        },
        "rafamadriz/friendly-snippets",
      },
    },

    -- auto pairs
    {
      "windwp/nvim-autopairs",
      config = function()
        require("config.autopairs").setup()
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      }
    },

    -- auto tag
    {
      "windwp/nvim-ts-autotag",
      event = "insertenter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      }
    },

    -- end wise
    {
      "rrethy/nvim-treesitter-endwise",
      event = "insertenter",
      enabled = false,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      }
    },

    -- lsp
    "williamboman/nvim-lsp-installer",
    "ray-x/lsp_signature.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "lua-dev.nvim",
    "vim-illuminate",
    "null-ls.nvim",
    "folke/lua-dev.nvim",
    "RRethy/vim-illuminate",
    "jose-elias-alvarez/null-ls.nvim",
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      config = function()
        require("fidget").setup {}
      end,
    },
    'nvim-lua/lsp-status.nvim',
    'nvim-lua/lsp_extensions.nvim',
    {'glepnir/lspsaga.nvim', branch = 'main'},
    {
      "neovim/nvim-lspconfig",
      lazy = true,
      event = "bufreadpre",
      -- wants = { "nvim-lsp-installer", "lsp_signature.nvim", "cmp-nvim-lsp" },  -- for nvim-cmp
      -- wants = { "nvim-lsp-installer", "lsp_signature.nvim", "coq_nvim" },  -- for coq.nvim
      config = function()
        require("config.lsp").setup()
      end,
    },

    -- Terminal
    {
      "akinsho/toggleterm.nvim",
      config = function()
        require("config.toggleterm").setup()
      end,
    },
  }

  -- Init and start lazy
  local lazy = require "lazy"
  lazy.setup(plugins)
end

return M
