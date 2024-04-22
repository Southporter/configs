local ok, flutter = pcall(require, 'flutter-tools')

if ok then
    flutter.setup{
      flutter_lookup_cmd = "rtx where flutter"
    }

    require('telescope').load_extension("flutter")


    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope flutter commands<CR>", opts)
end
