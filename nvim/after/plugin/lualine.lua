require('lualine').setup {
    sections = {lualine_c = {"filename", require('nvim-treesitter').statusline}}
}

