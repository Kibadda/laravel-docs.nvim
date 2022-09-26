# laravel-docs.nvim

A telescope.nvim extension that offers [Laravel](https://laravel.com/docs) documentation shortcuts.

## Requirements
 - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

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
      preview = true,                      -- show telescope preview
      preview_with_glow = false,           -- use glow as telescope previewer
      directory = "~/.cache/laravel-docs", -- where to clone the laravel docs github repo
    },
  },
}

require("telescope").load_extension "laravel-docs"
```

## Usage
Either run `:Telescope laravel-docs laravel_docs` or map it to a key, e.g.:
```lua
vim.keymap.set("n", "<Leader>sl", "<Cmd>Telescope laravel-docs laravel_docs<CR>")
```

## Roadmap
 - [x] Better listing of available documentation links
 - [x] Preview of hovered documentation
 - [ ] Tests
 - [x] (auto) generation of Laravel documentation table of contents

# License
MIT License
