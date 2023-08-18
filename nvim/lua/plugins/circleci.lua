return {
  "tomoakley/circleci.nvim",
  config = function()
    require("nvim-circleci").setup {
      project_slug = "gh/Thinkei/career-page",
    }
  end,
}
