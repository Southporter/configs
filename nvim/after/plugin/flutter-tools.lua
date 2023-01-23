require("flutter-tools").setup{
  flutter_lookup_cmd = "asdf where flutter"
}

require('telescope').load_extension("flutter")


local opts = { noremap = true }
vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope flutter commands<CR>", opts)
