local ok, telescope = pcall(require, "telescope")

if not ok then
  error "This plugin needs telescope installed"
end

local laravel_docs = require "laravel-docs"
local picker = require "laravel-docs.picker"

return telescope.register_extension {
  setup = laravel_docs.setup,
  exports = {
    ["laravel-docs"] = picker.laravel_docs,
  },
}
