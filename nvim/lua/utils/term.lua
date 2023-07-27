local M = {}

local Terminal = require("toggleterm.terminal").Terminal

-- Git client
local git_tui = "lazygit"

local git_client = Terminal:new {
  cmd = git_tui,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
  close_on_exit = false,
}

function M.git_client_toggle()
  git_client:toggle()
end

return M
