local M = {}

function M.defaults()
  ---@class LaravelDocsConfig
  local defaults = {
    version = "10.x",
    directory = vim.fn.stdpath "cache" .. "/laravel-docs",
    preview = true,
    glow = false,
    log = vim.fn.stdpath "state" .. "/laravel-docs.log",
  }
  return defaults
end

---@type LaravelDocsConfig
M.options = {}

---@param user_config? LaravelDocsConfig
function M.set(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults(), user_config or {})
end

return M
