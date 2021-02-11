if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugins')

" Theming
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhartington/oceanic-next'

" Navigation/Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'wincent/ferret'

" Code Help
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
" Plug 'Valloric/YouCompleteMe', { 'for': ['go', 'rust', 'typescript', 'javascript', 'typescript.tsx', 'javascript.jsx', 'python'], 'do': 'python3 ~/.vim/plugins/YouCompleteMe/install.py --clang-completer --ts-completer --go-completer --rust-completer', 'commit': '4e480a3' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lejafar/vim-pipenv-ycm', { 'for': ['python'] }
Plug 'editorconfig/editorconfig-vim'

" Language Specific
Plug 'yuezk/vim-js', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['javascript.jsx', 'typescript.tsx'] }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript.tsx' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'martinda/jenkinsfile-vim-syntax', { 'for': 'Jenkinsfile' }
Plug 'ekalinin/dockerfile.vim', { 'for': ['Dockerfile', 'yaml.docker-compose'] }
Plug 'cespare/vim-toml', { 'for': 'toml' }


" Ergonomics
Plug 'tpope/vim-obsession'

" Need to be last
Plug 'ryanoasis/vim-devicons'

call plug#end()

syntax enable
filetype plugin indent on
if (has("termguicolors"))
  set termguicolors
endif

let g:jsx_ext_required=0
let g:ale_linters = { 'javascript': ['eslint'], 'typescript': ['tsserver', 'tslint', 'prettier', 'eslint'] }

set backupdir=~/.vim/backups
set directory=~/.vim/backups

set listchars=eol:¬,tab:>-,trail:~
set list

set encoding=UTF-8

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set number
" set relativenumber

set incsearch hls

set noswapfile

let g:rustfmt_autosave = 1
let g:airline#extensions#ycm#enabled = 0

colorscheme OceanicNext

map <C-p> :Files<CR>

map <C-n> :NERDTreeToggle<CR>

let $FZF_DEFAULT_COMMAND = 'ag -g ""'


" CoC config
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
