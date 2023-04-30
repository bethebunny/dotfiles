set nocompatible
filetype off

"PLUGINS
"END PLUGINS

syntax on
filetype plugin indent on

let mapleader = ","

set modelines=0
set number 
set ruler
set visualbell
set encoding=utf-8

set wrap
set textwidth=88
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

set matchpairs+=<:>
set hidden
set ttyfast
set laststatus=2
set showmode
set showcmd

set hlsearch
set incsearch
set smartcase
map <space> :noh<cr>:echon ''<cr>

map <leader>w <C-w>

map <leader>. :w<cr>
map <leader><leader> <C-^>
map <leader>b :buffers<cr>:buffer 

" Color scheme
set t_Co=256
set background=dark
"colorscheme molokai
