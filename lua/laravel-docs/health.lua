local M = {}

function M.check()
  vim.health.report_start "laravel-docs report"

  if not pcall(require, "telescope") then
    vim.health.report_error "telescope is not installed"
  else
    vim.health.report_ok "telescope is installed"
  end

  local Config = require "laravel-docs.config"
  if Config.options.preview then
    if Config.options.glow then
      if vim.fn.executable "glow" == 0 then
        vim.health.report_error "previewer set to glow but glow is not installed"
      else
        vim.health.report_ok "glow is installed"
      end
    end
  end

  local valid = vim.tbl_keys(Config.defaults())
  for opt in pairs(Config.options) do
    if not vim.tbl_contains(valid, opt) then
      vim.health.report_warn("unknown option: " .. opt)
    end
  end
end

return M
