local Job = require "plenary.job"
local laravel_docs = require "laravel-docs"

local M = {}

function M.find_doc_sites()
  local directory = vim.fn.fnamemodify(laravel_docs.opts.directory, ":p")

  local ls = Job:new {
    command = "ls",
    args = {
      directory,
    },
  }
  ls:sync()

  local results = {}

  for _, file in ipairs(ls:result()) do
    local slug = vim.split(file, ".", { plain = true })[1]

    local split = vim.split(slug, "-")
    for i, part in ipairs(split) do
      split[i] = string.gsub(part, "^%l", string.upper)
    end

    table.insert(results, {
      slug = slug,
      name = table.concat(split, " "),
      path = directory .. file,
    })
  end

  return results
end

return M
