set nocompatible

filetype plugin indent on
syntax enable

set keywordprg=":help"

set autoindent
set backspace=indent,eol,start

set ttimeout
set ttimeoutlen=50

set incsearch
set hlsearch

set laststatus=2

let mapleader = ","
let g:mapleader = ","

nnoremap <Leader>v <C-w>v<C-w>l
nnoremap <Leader>s <C-w>s
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent> <Leader>DD :exe ":profile start profile.log"<CR>:exe ":profile func *"<CR>:exe ":profile file *"<CR>
nnoremap <silent> <Leader>DP :exe ":profile pause"<CR>
nnoremap <silent> <Leader>DC :exe ":profile continue"<CR>
nnoremap <silent> <Leader>DQ :exe ":profile pause"<CR>:noautocmd qall!<CR>
