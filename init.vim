if empty(glob('~/.config/nvim/autoload/plug.vim'))
  :exe '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/cmp-cmdline'
Plug 'f3fora/cmp-spell'
Plug 'hrsh7th/nvim-cmp'
Plug 'windwp/nvim-autopairs'

" Language Specific
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'ekalinin/dockerfile.vim', { 'for': ['Dockerfile', 'yaml.docker-compose'] }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'dag/vim-fish', { 'for': 'fish' }

" Navigation/Finding
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-treesitter/playground'
Plug 'ThePrimeagen/harpoon'

" Styling
Plug 'arcticicestudio/nord-vim'

" Needs to be last
Plug 'ryanoasis/vim-devicons'

call plug#end()

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set number

set listchars=eol:¬,tab:>-,trail:~
set list

set noswapfile
set encoding=UTF-8

colorscheme nord

let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 20

lua <<EOF
  require'lspconfig'.terraformls.setup{}
--  require'lspconfig'.pyright.setup{}
  require'lspconfig'.rls.setup{}
  require'nvim-autopairs'.setup{}
  local cmp = require'cmp'
  cmp.setup{
    sources = {
      { name = 'spell' },
      { name = 'buffer' },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'cmdline' },
      { name = 'emoji' },
    },
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
  }
EOF
autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()

command Mark :lua require('harpoon.mark').add_file()
command ViewMark :lua require("harpoon.ui").toggle_quick_menu()

let mapleader=" "
nnoremap <C-n> :Lexplore<CR>
nnoremap <C-p> :Telescope<CR>
nnoremap <silent><leader>m :lua require('harpoon.mark').add_file()<CR>
nnoremap <C-h> :lua require('harpoon.ui').toggle_quick_menu()<CR>
nnoremap <leader>h :lua require('harpoon.ui').toggle_quick_menu()<CR>
nnoremap <silent><C-j> :lua require('harpoon.ui').nav_file(1)<CR>
nnoremap <silent><C-k> :lua require('harpoon.ui').nav_file(2)<CR>
nnoremap <silent><C-l> :lua require('harpoon.ui').nav_file(3)<CR>
nnoremap <silent><C-;> :lua require('harpoon.ui').nav_file(4)<CR>
