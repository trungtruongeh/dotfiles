local M = {}

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name })
end

function M.is_empty(s)
  return s == nil or s == ""
end

function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "q!"
      end
    end)
  else
    vim.cmd "q!"
  end
end

function M.get_repo_name()
  if
    #vim.api.nvim_list_tabpages() > 1 and vim.fn.trim(vim.fn.system "git rev-parse --is-inside-work-tree") == "true"
  then
    return vim.fn.trim(vim.fn.system "basename `git rev-parse --show-toplevel`")
  end
  return ""
end

-- function M.nvim_version(val)
--   local version = (vim.version().major .. "." .. vim.version().minor) + 0.0
--   val = val or 0.7
--   if version >= val then
--     return true
--   else
--     return false
--   end
-- end
--
-- function M.nvim_nightly()
--   return M.nvim_version(0.7)
-- end

return M
