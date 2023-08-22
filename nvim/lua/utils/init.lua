local M = {}

function M.getCurrentProject()
  local currentDir = vim.fn.getcwd()
  local subDirs = vim.fn.split(currentDir, "/")
  local currentProject = subDirs[#subDirs]
  return currentProject
end

function M.openLink(link)
  os.execute("open " .. link)
end

function M.openCI(workflow)
  M.openLink("https://circleci.com/gh/Thinkei/workflows/" .. workflow)
end

function M.openCurrentCIBranch()
  local currentDir = vim.fn.getcwd()
  local subDirs = vim.fn.split(currentDir, "/")
  local currentProject = subDirs[#subDirs]
  local currentGitBranch = vim.fn.system("git branch --show-current | tr -d '\n'")
  M.openCI('' .. currentProject .. '/tree/' .. currentGitBranch)
end

return M
