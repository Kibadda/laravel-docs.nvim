local Job = require "plenary.job"
local config = require "laravel-docs.config"

local M = {}

local generating = false

local function ensure_one_git_process(callback)
  if not generating then
    generating = true
    callback()
    generating = false
  end
end

local function clone_repository()
  Job:new({
    command = "git",
    args = {
      "clone",
      "-q",
      "-b",
      config.version(),
      "https://github.com/laravel/docs.git",
      vim.fn.expand(config.directory()),
    },
  }):sync()
end

local function switch_branch()
  Job:new({
    command = "git",
    args = {
      "switch",
      config.version(),
    },
    cwd = vim.fn.expand(config.directory()),
  }):sync()
end

local function update_repository()
  Job:new({
    command = "git",
    args = { "pull" },
    cwd = vim.fn.expand(config.directory()),
  }):sync()
end

function M.generate()
  if vim.fn.isdirectory(vim.fn.expand(config.directory())) == 0 then
    ensure_one_git_process(clone_repository)
  else
    ensure_one_git_process(function()
      switch_branch()
      update_repository()
    end)
  end
end

return M
