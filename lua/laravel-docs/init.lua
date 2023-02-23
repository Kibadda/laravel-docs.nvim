local M = {}

---@param user_config? LaravelDocsConfig
function M.setup(user_config)
  require("laravel-docs.config").set(user_config)

  require("laravel-docs.docs").generate()
end

return M
