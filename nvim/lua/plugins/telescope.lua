return {
  'junegunn/fzf.vim',
  'junegunn/fzf',
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim",  "nvim-telescope/telescope-fzf-native.nvim", 'junegunn/fzf' },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      }

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      telescope.load_extension "fzf"
      telescope.load_extension "projects"
    end,
  },
}
