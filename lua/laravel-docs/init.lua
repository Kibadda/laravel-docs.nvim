local config = require "laravel-docs.config"

local M = {}

function M.setup(opts)
  config.setup(opts)

  require("laravel-docs.docs").generate()
end

return M
