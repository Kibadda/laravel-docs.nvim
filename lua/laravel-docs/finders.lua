local M = {}

function M.find_doc_sites()
  local Config = require "laravel-docs.config"
  local directory = vim.fn.expand(Config.options.directory)

  local files = vim.fs.find(function(file)
    return string.match(file, ".md$") ~= nil and string.find(file, "readme.md") == nil
  end, {
    path = directory,
    type = "file",
    limit = math.huge,
  })

  local results = {}

  for _, file in ipairs(files) do
    local path_split = vim.split(file, "/", { plain = true })
    local slug = vim.split(path_split[#path_split], ".", { plain = true })[1]

    local split = vim.split(slug, "-", { plain = true })
    for i, part in ipairs(split) do
      split[i] = part:gsub("^%l", string.upper)
    end

    table.insert(results, {
      slug = slug,
      name = table.concat(split, " "),
      path = file,
    })
  end

  return results
end

function M.find_sub_headings(doc_site)
  local Config = require "laravel-docs.config"
  local directory = vim.fn.expand(Config.options.directory)
  local file = ("%s/%s.md"):format(directory, doc_site)
  local file_string = table.concat(vim.fn.readfile(file), "\n")

  local captures = {}

  local root = vim.treesitter.get_string_parser(file_string, "markdown", {}):parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "markdown",
    [[
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
  )

  for _, match in query:iter_matches(root, "", 1, -1) do
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
      name = capture.text:sub(2),
      type = capture.type:len(),
      anchor = capture.link:match [["([^"]+)]],
      lnum = capture.lnum + 1,
    })
  end

  return results
end

return M
