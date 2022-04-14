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

local version

M.setup = function (config)
  version = config.version or nil
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
    attach_mappings = function()
      actions.select_default:replace(function()
        local url = baseurl
        if version ~= nil then
          url = url .. '/' .. version
        end

        local open_docs = function ()
          local selection = action_state.get_selected_entry()
          os.execute('xdg-open ' .. url .. '/' .. selection[1])
        end

        actions.select_default:replace(open_docs)
      end)
      return true
    end,
  }):find()
end

return M

