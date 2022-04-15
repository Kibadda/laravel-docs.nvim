# laravel-docs.nvim

A telescope.nvim extension that offers [Laravel](https://laravel.com/docs) documentation shortcuts.

## Requirements
 - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation
Install with your favorite package manager

e.g. [Packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
  "Kibadda/laravel-docs.nvim",
  config = function()
    require"telescope".load_extension("laraveldocs")
  end,
}
```

## Usage
after installation, there are two available commands:
1. LaravelDocs
    ```
    :LaravelDocs
    ```
    Opens the telescope picker \
    Example mapping:
    ```
    vim.api.nvim_set_keymap("n", "<leader>l", ":LaravelDocs<CR>", {noremap = true, silent = true})
    ```
1. LaravelDocsGenerate
    ```
    :LaravelDocsGenerate
    ```
    This generates new documentation links \
    Should be called after changing version of Laravel in config \
    `TODO: better and faster generation (currently clones Laravel Docs github)` 

## Configuration
The only configuration option available right now is the version number for Laravel.

Example Configuration:
```lua
require('telescope').setup {
  extensions = {
    laraveldocs = {
      version = nil -- e.g. 9.x or 8.x
    },
  },
}
```

## Roadmap
 - [x] Better listing of available documentation links
 - [ ] Preview of hovered documentation
 - [ ] Tests
 - [x] (auto) generation of Laravel documentation table of contents

# License
MIT License
