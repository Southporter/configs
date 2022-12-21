require('nvim-autopairs').setup{}

vim.api.nvim_set_keymap("n","<C-n>", ":NvimTreeToggle<CR>", { noremap = true })
require'nvim-tree'.setup {}

local silent = { noremap = true, silent = true }
local noremap = { noremap = true }
vim.api.nvim_set_keymap("n","<leader>m", ":lua require('harpoon.mark').add_file()<CR>", silent)
vim.api.nvim_set_keymap("n","<C-h>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", noremap)
vim.api.nvim_set_keymap("n","<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", noremap)
vim.api.nvim_set_keymap("n","<C-j>", ":lua require('harpoon.ui').nav_file(1)<CR>", silent)
vim.api.nvim_set_keymap("n","<C-k>", ":lua require('harpoon.ui').nav_file(2)<CR>", silent)
vim.api.nvim_set_keymap("n","<C-l>", ":lua require('harpoon.ui').nav_file(3)<CR>", silent)
vim.api.nvim_set_keymap("n","<C-;>", ":lua require('harpoon.ui').nav_file(4)<CR>", silent)
vim.cmd([[
  command Mark :lua require('harpoon.mark').add_file()
  command ViewMark :lua require('harpoon.ui').toggle_quick_menu()
]])
