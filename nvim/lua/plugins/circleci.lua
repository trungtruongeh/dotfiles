return {
  "tomoakley/circleci.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("nvim-circleci").setup {
      project_slug = "gh/Thinkei/career-page",
      require("telescope").load_extension("circleci")
    }
  end,
}
