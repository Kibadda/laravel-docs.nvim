local ok, telescope = pcall(require, "telescope")

if not ok then
  error "This plugin needs telescope installed"
end

return telescope.register_extension {
  setup = require("laravel-docs").setup,
  exports = {
    ["laravel-docs"] = require("laravel-docs.picker").laravel_docs,
  },
}
