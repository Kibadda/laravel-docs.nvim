-- telescope modules
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

-- laravel docs modules
local docnames = require('telescope._extensions.laraveldocs.docs')

local baseurl = 'https://laravel.com/docs/'

local M = {}

M.setup = function (config)
end

M.laraveldocs = function (opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Laravel Documentation',
    results_title = 'Sites',
    finder = finders.new_table {
      results = docnames
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        local selection = action_state.get_selected_entry()

        local url = baseurl .. '/'

        os.execute('xdg-open 2>/dev/null ' .. url .. selection[1])
      end)
      return true
    end,
  }):find()
end

return M
