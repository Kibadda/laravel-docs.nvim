local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local docnames = require('telescope._extensions.laravel-docs.docs')

local baseurl = 'https://laravel.com/docs/'

local docs = function (opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = 'Laravel Documentation',
    finder = finders.new_table {
      results = docnames
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        os.execute('xdg-open ' .. baseurl .. selection[1])
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension {
  exports = {
    laraveldocs = docs,
  },
}
