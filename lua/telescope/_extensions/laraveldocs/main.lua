-- telescope modules
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

-- laravel docs modules
local generator = require('telescope._extensions.laraveldocs.generation')
local docs = require('telescope._extensions.laraveldocs.docs')

-- base url for laravel documentation
local baseurl = 'https://laravel.com/docs/'

local M = {
  -- url without version goes to newest documentation
  version = nil,
  docs = {},
}

M.laraveldocs = function (opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Laravel Documentation',
    results_title = 'Sites',
    finder = finders.new_table {
      results = M.docs
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        local selection = action_state.get_selected_entry()

        local url = baseurl

        -- add version string if provided by user
        if M.version ~= nil then
          url = url .. M.version .. '/'
        end

        os.execute('xdg-open 2>/dev/null ' .. url .. selection[1])
      end)
      return true
    end,
  }):find()
end

M.generatedocs = function (version)
  M.docs = generator.generate(version)
end

M.setup = function (config)
  -- override version by user config
  M.version = config.version or nil
  -- M.generatedocs(M.version)
end

return M
