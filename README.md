# laravel-docs.nvim

A telescope.nvim extension that offers [Laravel](https://laravel.com/docs) documentation shortcuts.

## Requirements
 - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

Packer.nvim
```lua
use {
  "Kibadda/laravel-docs.nvim",
  config = function()
    require"telescope".load_extension("laraveldocs")
  end,
}
```

## Usage
```
:Telescope laraveldocs
```
Example mapping:
```
vim.api.nvim_set_keymap("n", "<leader>l", ":Telescope laraveldocs<CR>", {noremap = true, silent = true})
```

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
 - [ ] Better listing of available documentation links
 - [ ] Preview of hovered documentation
 - [ ] Tests
 - [ ] auto generation of Laravel documentation table of contents

# License
MIT License
