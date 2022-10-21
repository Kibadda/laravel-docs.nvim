local Job = require "plenary.job"
local config = require "laravel-docs.config"

local M = {}

local generating = false

local function start_job_chain(job_opts)
  if not generating then
    generating = true
    for i, opts in ipairs(job_opts) do
      if i == #job_opts then
        opts.on_exit = function()
          generating = false
        end
        Job:new(opts):start()
      else
        Job:new(opts):sync()
      end
    end
  end
end

function M.generate()
  if vim.fn.isdirectory(vim.fn.expand(config.directory())) == 0 then
    start_job_chain {
      {
        command = "git",
        args = {
          "clone",
          "-q",
          "-b",
          config.version(),
          "https://github.com/laravel/docs.git",
          vim.fn.expand(config.directory()),
        },
      },
    }
  else
    start_job_chain {
      {
        command = "git",
        args = {
          "switch",
          config.version(),
        },
        cwd = vim.fn.expand(config.directory()),
      },
      {
        command = "git",
        args = { "pull" },
        cwd = vim.fn.expand(config.directory()),
      },
    }
  end
end

return M
