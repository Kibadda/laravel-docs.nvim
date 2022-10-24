local Job = require "plenary.job"
local config = require "laravel-docs.config"

local M = {}

function M.find_doc_sites()
  local directory = vim.fn.expand(config.directory())

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

    local split = vim.split(slug, "-", { plain = true })
    for i, part in ipairs(split) do
      split[i] = string.gsub(part, "^%l", string.upper)
    end

    table.insert(results, {
      slug = slug,
      name = table.concat(split, " "),
      path = string.format("%s/%s", directory, file),
    })
  end

  return results
end

function M.find_sub_headings(doc_site)
  local directory = vim.fn.expand(config.directory())
  local file = string.format("%s/%s.md", directory, doc_site)
  local file_string = table.concat(vim.fn.readfile(file), "\n")

  local query_string = [[
    [
      (
        (section
          (paragraph
            (inline) @link) .)
        .
        (section
          (atx_heading
            (_) @type
            heading_content: (inline) @text))
      )
      (
        (section
          (section
            (paragraph
              (inline) @link) .) .)
        .
        (section
          (atx_heading
            (_) @type
            heading_content: (inline) @text))
      )
      (
        (paragraph
          (inline) @link)
        .
        (section
          (atx_heading
            (_) @type
            heading_content: (inline) @text))
      )
    ]
  ]]

  local captures = {}

  local root = vim.treesitter.get_string_parser(file_string, "markdown", {}):parse()[1]:root()
  local query = vim.treesitter.parse_query("markdown", query_string)

  for _, match in query:iter_matches(root) do
    local entry = {}
    for id, node in pairs(match) do
      entry[query.captures[id]] = vim.treesitter.get_node_text(node, file_string)
      if query.captures[id] == "text" then
        entry.lnum = node:start()
      end
    end
    table.insert(captures, entry)
  end

  local results = {}
  for _, capture in ipairs(captures) do
    table.insert(results, {
      name = string.sub(capture.text, 2),
      type = string.len(capture.type),
      anchor = string.match(capture.link, [["([^"]+)]]),
      lnum = capture.lnum + 1,
    })
  end

  return results
end

return M
