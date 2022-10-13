local Job = require "plenary.job"
local laravel_docs = require "laravel-docs"

local repository = "https://github.com/laravel/docs.git"

local generating = false

local M = {}

function M.generate()
  local directory = vim.fn.fnamemodify(laravel_docs.opts.directory, ":p")

  if vim.fn.isdirectory(directory) == 0 then
    if not generating then
      generating = true
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
          -- if result_var == 1 then
          --   vim.notify("Generation failed", 4, { title = "Larvel Documentation" })
          -- else
          --   vim.notify("Generation successful", 2, { title = "Larvel Documentation" })
          -- end
          generating = false
        end,
      }):start()
    end
  else
    if not generating then
      generating = true
      Job:new({
        command = "git",
        args = { "pull" },
        cwd = directory,
        on_exit = function(_, result_var)
          -- if result_var == 1 then
          --   vim.notify("Update failed", 4, { title = "Larvel Documentation" })
          -- else
          --   vim.notify("Update successful", 2, { title = "Larvel Documentation" })
          -- end
          generating = false
        end,
      }):start()
    end
  end
end

return M
