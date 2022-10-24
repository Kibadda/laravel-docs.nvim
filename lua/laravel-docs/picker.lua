local Job = require "plenary.job"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local laravel_docs_finders = require "laravel-docs.finders"
local config = require "laravel-docs.config"

local base_url = "https://laravel.com/docs/"

local M = {}

function M.laravel_docs(opts)
  opts = opts or {}

  local version = config.version()

  local results = laravel_docs_finders.find_doc_sites()

  local picker_opts = {
    prompt_title = "Laravel Documentation",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          path = entry.path,
          display = entry.name,
          ordinal = entry.name,
          entry = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    mappings = {
      i = {
        ["<C-o>"] = false,
      },
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        opts.doc_site = action_state.get_selected_entry().entry
        M.sub_heading(opts)
      end)

      local function open_doc_site()
        local selection = action_state.get_selected_entry().entry
        actions.close(prompt_bufnr)

        local url = base_url
        if version then
          url = ("%s%s/"):format(url, version)
        end
        Job:new({
          command = "xdg-open",
          args = {
            ("%s%s"):format(url, selection.slug),
          },
        }):start()
      end

      map("i", "<C-o>", open_doc_site)

      map("n", "o", open_doc_site)

      return true
    end,
  }

  if config.preview() then
    if config.preview_with_glow() and vim.fn.executable "glow" == 1 then
      picker_opts.previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return {
            "glow",
            "-p",
            entry.path,
          }
        end,
      }
    else
      picker_opts.previewer = conf.file_previewer {}
    end
  end

  pickers.new(opts, picker_opts):find()
end

function M.sub_heading(opts)
  opts = opts or {}

  local version = config.version()

  local results = laravel_docs_finders.find_sub_headings(opts.doc_site.slug)

  local picker_opts = {
    prompt_title = ("Laravel Documentation %s"):format(opts.doc_site.name),
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          path = opts.doc_site.path,
          display = entry.name,
          ordinal = entry.name,
          lnum = entry.lnum,
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
          url = ("%s%s/"):format(url, version)
        end
        Job:new({
          command = "xdg-open",
          args = {
            ("%s%s#%s"):format(url, opts.doc_site.slug, selection.anchor),
          },
        }):start()
      end)
      return true
    end,
  }

  if config.preview() then
    picker_opts.previewer = conf.grep_previewer {}
  end

  pickers.new(opts, picker_opts):find()
end

return M
