local Job = require "plenary.job"
local laravel_docs = require "laravel-docs"

local repository = "https://github.com/laravel/docs.git"

local cloning = false

local M = {}

function M.generate()
  local directory = vim.fn.fnamemodify(laravel_docs.opts.directory, ":p")

  if not cloning and vim.fn.isdirectory(directory) == 0 then
    cloning = true
    local args
    if laravel_docs.opts.version then
      args = {
        "clone",
        "-q",
        "-b",
        laravel_docs.opts.version,
        repository,
        directory,
      }
    else
      args = {
        "clone",
        "-q",
        repository,
        directory,
      }
    end
    Job:new({
      command = "git",
      args = args,
      on_exit = function(_, result_var)
        if result_var == 1 then
          vim.notify("Generation failed", "error", { title = "Larvel Documentation" })
        else
          vim.notify("Generation successful", "info", { title = "Larvel Documentation" })
        end
        cloning = false
      end,
    }):start()
  end
end

return M
