# laravel-docs.nvim

A telescope.nvim extension that offers [Laravel](https://laravel.com/docs) documentation shortcuts.

## Requirements
 - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
 - optional: [glow](https://github.com/charmbracelet/glow)

## Installation
Install with your favorite package manager

e.g. [Packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "Kibadda/laravel-docs.nvim"
```

## Setup
```lua
require("telescope").setup {
  extensions = {
    ["laravel-docs"] = {
      version = nil,                       -- version string, e.g. "8.x", default newest
      preview = true,                      -- show telescope preview
      preview_with_glow = false,           -- use glow as telescope previewer
      directory = "~/.cache/laravel-docs", -- where to clone the laravel docs github repo
    },
  },
}

require("telescope").load_extension "laravel-docs"
```

## Usage
Either run `:Telescope laravel-docs` or map it to a key, e.g.:
```lua
vim.keymap.set("n", "<Leader>sl", "<Cmd>Telescope laravel-docs<CR>")
```
In Telescope picker:
 - `<C-o>/o` (insert/normal) opens selected doc site in browser
 - `<CR>` opens Telescope picker with all subheadings

## Roadmap
 - [x] Better listing of available documentation links
 - [x] Preview of hovered documentation
 - [x] (auto) generation of Laravel documentation
 - [ ] fix preview not loading bug with glow (only after pressing scroll buttons once)
 - [ ] sub categories

# License
MIT License
