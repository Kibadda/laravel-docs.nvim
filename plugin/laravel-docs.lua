if vim.g.loaded_LaravelDocs == 1 then
  return
end

vim.g.loaded_LaravelDocs = 1

vim.api.nvim_create_user_command("LaravelDocs", function(args)
  local picker = require "laravel-docs.picker"
  local arguments = vim.split(vim.trim(args.args), "%s+")
  if vim.trim(args.args) == "" or #arguments < 1 then
    picker.laravel_docs()
  else
    local doc_sites = {}
    for _, doc_site in ipairs(require("laravel-docs.finders").find_doc_sites()) do
      doc_sites[doc_site.slug] = doc_site
    end
    picker.sub_heading {
      doc_site = doc_sites[arguments[1]],
    }
  end
end, {
  nargs = "?",
  desc = "LaravelDocs",
  complete = function(_, line)
    if line:match "^%s*LaravelDocs %w+ " then
      return {}
    end

    local doc_sites = {}
    for _, doc_site in ipairs(require("laravel-docs.finders").find_doc_sites()) do
      table.insert(doc_sites, doc_site.slug)
    end

    local prefix = line:match "^%s*LaravelDocs (%w*)" or ""
    return vim.tbl_filter(function(key)
      return key:find(prefix) == 1
    end, doc_sites)
  end,
})

vim.api.nvim_create_user_command("LaravelDocsUpdate", function()
  require("laravel-docs.docs").generate()
end, {
  nargs = 0,
  desc = "LaravelDocsUpdate",
})
