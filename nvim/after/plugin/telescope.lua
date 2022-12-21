
local telescope = require'telescope'
telescope.setup{}
telescope.load_extension('fzf')

local opts = { noremap = true }
vim.api.nvim_set_keymap("n","<C-p>", ":Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap("n","<C-t>", ":Telescope<CR>", opts)
vim.api.nvim_set_keymap("n","<C-g>", ":Telescope live_grep<CR>", opts)
vim.api.nvim_set_keymap("n","<leader>t", ":Telescope help_tags<CR>", opts)
