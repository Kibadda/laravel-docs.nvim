return require("telescope").register_extension {
  setup = require("laravel-docs").setup,
  exports = {
    ["laravel-docs"] = require("laravel-docs.telescope").laravel_docs,
  },
}
