if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'wincent/ferret'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'

Plug 'flazz/vim-colorschemes'
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
Plug 'wakatime/vim-wakatime'
Plug 'valloric/youcompleteme', {'do': './install.py --clang-completer --rust-completer --ts-completer --go-completer'}
Plug 'editorconfig/editorconfig-vim'
Plug 'hugolgst/vimsence'

Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
Plug 'mxw/vim-jsx', {'for': ['typescript.tsx', 'javascript.jsx']}

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
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

filetype plugin indent on
syntax on
set hls incsearch
set noswapfile

set path=.,**

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

let g:ale_linters = { 'javascript': ['eslint', 'tsserver'] }

let g:vimsence_client_id = '439476230543245312'
let g:vimsence_small_text = 'Vim'
let g:vimsence_small_image = 'vim'
let g:vimsence_editing_details = 'Editing: {}'
let g:vimsence_editing_state = 'Working in: {}'
let g:vimsence_file_explorer_text = 'In NERDTree'
let g:vimsence_file_explorer_details = 'Looking for files'

let g:rustfmt_autosave = 1
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
