return require("telescope").register_extension {
  setup = require("laravel-docs").setup,
  exports = {
    laravel_docs = require("laravel-docs.telescope").laravel_docs,
  },
}
