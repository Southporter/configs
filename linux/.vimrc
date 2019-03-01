if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
Plug 'majutsushi/tagbar'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'wakatime/vim-wakatime'
Plug 'mhartington/oceanic-next'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
call plug#end()

set background=dark

set backupdir=~/.vim/backups
set directory=~/.vim/backups

set listchars=eol:¬,tab:>-,trail:~,space:·
set list

set tabstop=2
set softtabstop=2
set shiftwidth=2

colorscheme OceanicNext

map <C-p> :Files<CR>

map <C-n> :NERDTreeToggle<CR>

let g:ale_linters = { 'javascript': ['eslint'] }
