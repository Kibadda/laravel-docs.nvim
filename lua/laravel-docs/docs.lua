local M = {}

local generating = false

function M.generate()
  if generating then
    return
  end

  local Config = require "laravel-docs.config"
  if vim.fn.isdirectory(vim.fn.expand(Config.options.directory)) == 0 then
    vim.system({
      "git",
      "clone",
      "-q",
      "-b",
      Config.options.version,
      "https://github.com/laravel/docs.git",
      vim.fn.expand(Config.options.directory),
    }, {}, function()
      generating = false
    end)
  else
    vim.system({ "git", "switch", Config.options.version }, { cwd = vim.fn.expand(Config.options.directory) }):wait()
    vim.system({ "git", "pull" }, { cwd = vim.fn.expand(Config.options.directory) }, function()
      generating = false
    end)
  end
end

return M
