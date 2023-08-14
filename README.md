# Uncrustify.nvim

Very small plugin to run Uncrustify from Neovim

## Raison d'être
I tried to make this work with the existing [null-ls builtin](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/uncrustify.lua)
but I wasn't able to for two reasons:

1. I couldn't figure out how to get it to pass only the selected text to stdin of the command it runs
2. null-ls has been archived, so even if I could get it to work, I couldn't merge it into the repo

Maybe someone else could figure it out, but this didn't take very long to make and it was fun.


## Installation
Packer:
```lua
use({
  "rickyelopez/uncrustify.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("uncrustify").setup({format_timeout = 5000})
  end,
})
```

## Configuration
Call the `setup()` function (either with Packer as shown above, or elsewhere in your config)
if you want to modify any of the default options. Available options are:

- `uncrustify_bin_path`  
  default: `"uncrustify"`  
  Path to use to run uncrustify  
- `uncrustify_cfg_path`  
  default: `vim.env.HOME .. "/.config/uncrustify.cfg"`  
  Path to the uncrustify config file  
  note: this does not presently expand env vars. Use `vim.env.VAR_NAME` to construct the path.  
- `filetype_mapping`  
  default: `{ c = "c", cpp = "cpp" }`  
  Table mapping vim filetypes to uncrustify filetypes  
- `format_timeout`  
  default: 3000  
  Timeout when running uncrustify  


## Usage
Define a keybind that calls the `format()` function in normal or visual modes. Eg. for `clangd` and `lspconfig`:
```lua
local on_attach = function(client, bufnr)
    if client.name and client.name == "clangd" then
        vim.keymap.set({ "n", "v" }, "<leader>f", require("uncrustify").format, { noremap = true })
    end
end
```
The above `on_attach` function can then be passed to the `lspconfig` setup function for clangd, in this case.

Note: in visual mode, Uncrustify is run with the `--frag` argument, which makes it assume that the first
line is indented correctly.
