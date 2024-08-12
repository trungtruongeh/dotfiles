local M = {}

local Terminal = require("toggleterm.terminal").Terminal

-- Git client
local keyset = vim.keymap.set
keyset("n", "<space><space>", ":ToggleTerm size=15<cr>", {silent = true})
keyset("n", "<space>t", ":ToggleTerm size=70 direction=vertical<cr>", {silent = true})

local lg_cmd = "lazygit -w $PWD"
if vim.v.servername ~= nil then
    lg_cmd = string.format(
                 "NVIM_SERVER=%s lazygit -ucf ~/.config/nvim/lazygit.toml -w $PWD",
                 vim.v.servername)
end

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"

local lazygit = Terminal:new({
    cmd = lg_cmd,
    count = 5,
    direction = "float",
    float_opts = {
        border = "double",
        width = function() return vim.o.columns end,
        height = function() return vim.o.lines end
    },
    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>",
                                    {noremap = true, silent = true})
    end
})

function Edit(fn, line_number)
    local edit_cmd = string.format(":e %s", fn)
    if line_number ~= nil then
        edit_cmd = string.format(":e +%d %s", line_number, fn)
    end
    vim.cmd(edit_cmd)
end

function M.git_client_toggle()
  lazygit:toggle()
end

return M
