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
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  { "onsails/lspkind.nvim" }, 
  { 'nvim-lua/lsp-status.nvim' },

  {
    'hrsh7th/nvim-cmp',
    event = "BufReadPre",
    config = cmpSetup,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = { "nvim-lua/lsp-status.nvim" },
    event = "BufReadPre",
    config = lspconfigSetup,
  }
}
