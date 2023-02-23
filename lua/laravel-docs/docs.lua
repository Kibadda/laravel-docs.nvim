local M = {}

local generating = false

local function start_job_chain(job_opts)
  if not generating then
    generating = true
    local Job = require "plenary.job"
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
  local Config = require "laravel-docs.config"
  if vim.fn.isdirectory(vim.fn.expand(Config.options.directory)) == 0 then
    start_job_chain {
      {
        command = "git",
        args = {
          "clone",
          "-q",
          "-b",
          Config.options.version,
          "https://github.com/laravel/docs.git",
          vim.fn.expand(Config.options.directory),
        },
      },
    }
  else
    start_job_chain {
      {
        command = "git",
        args = { "switch", Config.options.version },
        cwd = vim.fn.expand(Config.options.directory),
      },
      {
        command = "git",
        args = { "pull" },
        cwd = vim.fn.expand(Config.options.directory),
      },
    }
  end
end

return M
