# laravel-docs.nvim

A telescope.nvim extension that offers [Laravel](https://laravel.com/docs) documentation shortcuts.

## :package: Requirements
 - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
 - optional: [glow](https://github.com/charmbracelet/glow)

## :wrench: Installation
Install with your favorite package manager

e.g. [Packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "Kibadda/laravel-docs.nvim"
```

## :bulb: Setup
```lua
require("telescope").setup {
  extensions = {
    ["laravel-docs"] = {
      version = "9.x",                     -- one of: "6.x", "7.x", "8.x", "9.x", "master"
      preview = true,                      -- show telescope preview
      preview_with_glow = false,           -- use glow as telescope previewer
      directory = "$HOME/.cache/laravel-docs", -- where to clone the laravel docs github repo
    },
  },
}

require("telescope").load_extension "laravel-docs"
```

## :mag: Usage
Either run `:Telescope laravel-docs` or map it to a key, e.g.:
```lua
vim.keymap.set("n", "<Leader>sl", "<Cmd>Telescope laravel-docs<CR>")
```
In Telescope picker:
 - `<C-o>/o` (insert/normal) opens selected doc site in browser
 - `<CR>` opens Telescope picker with all subheadings

## :car: Roadmap
- [x] Better listing of available documentation links
- [x] Preview of hovered documentation
- [x] (auto) generation of Laravel documentation
- [x] sub headings
- [x] Bug: subheadings picker is not searchable
- [ ] Bug: glow preview sometimes not showing (only after pressing scroll buttons once)

# License
MIT License
