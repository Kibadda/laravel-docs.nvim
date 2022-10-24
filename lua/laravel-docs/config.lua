local M = {}

local config = {
  version = "9.x",
  directory = "$HOME/.cache/laravel-docs",
  preview = true,
  preview_with_glow = false,
}

function M.setup(user_config)
  user_config = user_config or {}

  vim.validate {
    config = { user_config, "table" },
  }

  vim.validate {
    version = {
      user_config.version,
      function(value)
        if not value then
          return true
        end
        local available_versions = { "6.x", "7.x", "8.x", "9.x", "master" }

        return vim.tbl_contains(available_versions, value),
          ("one of: %s"):format(table.concat(available_versions, ", "))
      end,
      "version number",
    },
    directory = { user_config.directory, "string", true },
    preview = { user_config.preview, "boolean", true },
    preview_with_glow = { user_config.preview_with_glow, "boolean", true },
  }

  config = vim.tbl_extend("force", config, user_config)
end

function M.directory()
  return config.directory
end

function M.version()
  return config.version
end

function M.preview()
  return config.preview
end

function M.preview_with_glow()
  return config.preview_with_glow
end

return M
