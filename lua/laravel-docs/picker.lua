local M = {}

local base_url = "https://laravel.com/docs/"

function M.laravel_docs(opts)
  opts = opts or {}

  local Config = require "laravel-docs.config"
  local conf = require("telescope.config").values

  local picker_opts = {
    prompt_title = "Laravel Documentation",
    finder = require("telescope.finders").new_table {
      results = require("laravel-docs.finders").find_doc_sites(),
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
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"

      actions.select_default:replace(function()
        opts.doc_site = action_state.get_selected_entry().entry
        M.sub_heading(opts)
      end)

      local function open_doc_site()
        local selection = action_state.get_selected_entry().entry
        actions.close(prompt_bufnr)

        local url = base_url
        if Config.options.version then
          url = ("%s%s/"):format(url, Config.options.version)
        end
        require("plenary.job")
          :new({
            command = "xdg-open",
            args = {
              ("%s%s"):format(url, selection.slug),
            },
          })
          :start()
      end

      map("i", "<C-o>", open_doc_site)
      map("n", "o", open_doc_site)

      return true
    end,
  }

  if Config.options.preview then
    if Config.options.glow and vim.fn.executable "glow" == 1 then
      picker_opts.previewer = require("telescope.previewers").new_termopen_previewer {
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

  require("telescope.pickers").new(opts, picker_opts):find()
end

function M.sub_heading(opts)
  opts = opts or {}

  local Config = require "laravel-docs.config"
  local conf = require("telescope.config").values

  local picker_opts = {
    prompt_title = ("Laravel Documentation %s"):format(opts.doc_site.name),
    finder = require("telescope.finders").new_table {
      results = require("laravel-docs.finders").find_sub_headings(opts.doc_site.slug),
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
      local actions = require "telescope.actions"
      local action_state = require "telescope.actions.state"

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        local selection = action_state.get_selected_entry().entry

        local url = base_url
        if Config.options.version then
          url = ("%s%s/"):format(url, Config.options.version)
        end
        require("plenary.job")
          :new({
            command = "xdg-open",
            args = {
              ("%s%s#%s"):format(url, opts.doc_site.slug, selection.anchor),
            },
          })
          :start()
      end)

      return true
    end,
  }

  if Config.options.preview then
    picker_opts.previewer = conf.grep_previewer {}
  end

  require("telescope.pickers").new(opts, picker_opts):find()
end

return M
