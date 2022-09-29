local Job = require "plenary.job"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local laravel_docs = require "laravel-docs"
local laravel_docs_finders = require "laravel-docs.finders"

local base_url = "https://laravel.com/docs/"

local M = {}

function M.laravel_docs(opts)
  opts = opts or {}

  local version = laravel_docs.opts.version

  local results = laravel_docs_finders.find_doc_sites()

  local picker_opts = {
    prompt_title = "Laravel Documentation",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry.path,
          display = entry.name,
          ordinal = entry.name,
          entry = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry().entry

        local url = base_url
        if version then
          url = url .. version .. "/"
        end
        Job:new({
          command = "xdg-open",
          args = {
            url .. selection.slug,
          },
        }):start()
      end)
      return true
    end,
  }

  if laravel_docs.opts.preview then
    if laravel_docs.opts.preview_with_glow and vim.fn.executable "glow" == 1 then
      picker_opts.previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return {
            "glow",
            "-p",
            entry.value,
          }
        end,
      }
    else
      picker_opts.previewer = conf.file_previewer {}
    end
  end

  pickers.new(opts, picker_opts):find()
end

return M
