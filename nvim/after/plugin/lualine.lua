require('lualine').setup {
  options = {
    icons_enabled = true,
    section_separators = {
      left = '\u{EB70}',
      right = '\u{eb6f}',
    },
    component_separators = {
      left = '\u{eab6}',
      right = '\u{eab5}',
    },
  },

    sections = {
      lualine_c = {"filename", require('nvim-treesitter').statusline}
    },
}

