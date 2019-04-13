call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-commentary'
Plug 'majutsushi/tagbar'
Plug 'wakatime/vim-wakatime'
Plug 'wincent/ferret'
Plug 'mhartington/oceanic-next'
Plug 'jparise/vim-graphql'
Plug 'tpope/vim-obsession'
call plug#end()

syntax enable
if (has("termguicolors"))
  set termguicolors
endif

let g:jsx_ext_required=0
let g:ale_linters = {'javascript': ['eslint']}

set backupdir=~/.vim/backups
set directory=~/.vim/backups

set listchars=eol:¬,tab:>-,trail:~,space:·
set list

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

colorscheme OceanicNext

map <C-p> :Files<CR>

map <C-n> :NERDTreeToggle<CR>

