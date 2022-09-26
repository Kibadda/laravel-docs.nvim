local M = {
  opts = {
    version = nil,
    directory = "~/.cache/laravel-docs",
    preview = true,
    preview_glow = false,
  },
}

function M.setup(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("keep", opts, M.opts)

  require("laravel-docs.docs").generate()
end

return M
