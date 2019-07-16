" .vimrc
"
" Author:   Larry Xu <hilarryxu@gmail.com>
" Updated:  2017/07/20
"
" This file changes a lot.

" prem {{{1
set nocompatible

let s:is_windows = has('win32') || has('win64')

filetype plugin indent on
syntax on

" config {{{1
let mapleader = ","
let maplocalleader = "\\"
nnoremap ; :

set backspace=indent,eol,start
set history=1000
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set updatetime=200
set ruler
set number
set showcmd
set wildmenu
set complete-=i
set completeopt=longest,menu
let do_syntax_sel_menu=1

" tab, indent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set smartindent

" fold
set foldmethod=marker
set foldlevelstart=0
nnoremap z0 zCz0

" search
set showmatch
set matchtime=2
set matchpairs+=<:>
set incsearch
set hlsearch
set noignorecase smartcase

" backup
set nobackup
set nowritebackup
set noswapfile

" statusline
set laststatus=2
set list listchars=tab:\|\ ,trail:.
set stl=%t\ %m\ %r\ [%{&fileencoding},%{&ff}%Y]\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

" encoding
set langmenu=zh_CN.UTF-8
set encoding=utf-8
set fileencodings=utf-8,gbk,chinese,cp936,gb18030,utf-16le,utf-16,big5,euc-jp,euc-kr,latin-1
set fileencoding=utf-8
set ffs=unix,dos,mac
set ff=unix

" wrap
set nowrap
set textwidth=80
set formatoptions=qrn1

" wildignore
set wildignore+=*.pyc,*.sqlite,*.sqlite3,cscope.out
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/nginx_runtime/*,*/build/*,*/logs/*

" gui
if has("gui_running")
  " egt
  set guioptions-=T
  set guioptions-=m
  set guioptions-=L
  set guioptions-=r
  set guioptions-=b
  set cursorline
  set cursorcolumn
  set paste
  set autochdir
  if has("win32")
    set guifont=Consolas_for_Powerline_FixedD:h10:cANSI
  endif
endif

" plugin {{{1
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" func {{{1
function! NilStripTrailingWhitespaces()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

function! NilTogglePaste()
  if (&paste == 1)
    set nopaste
    echo "Paste: nopaste"
  else
    set paste
    echo "Paste: paste"
  endif
endfunction

function! NilToggleBackground()
  if &background == "light"
    set background=dark
  else
    set background=light
  endif
endfunction

" mapping {{{1
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <expr> <Tab> pumvisible() ? "\<C-n>\<C-y>" : "\<Tab>"
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"
endfunction

" tab
nnoremap <Leader>an :tabn<CR>
nnoremap <Leader>ap :tabp<CR>
nnoremap <Leader>am :tabm
nnoremap <Leader>at :tabnew
nnoremap <Leader>as :tab split<CR>

" buffer
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bf :bfirst<CR>
nnoremap <Leader>bl :blast<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bk :bw<CR>

" toggle
nnoremap <silent> <Leader>tp :call NilTogglePaste()<CR>
nnoremap <silent> <Leader>tb :call NilToggleBackground()<CR>

" stuff
map <silent> <leader>ee :e $HOME/_vimrc<cr>
nnoremap <silent> <Leader>ss :call NilStripTrailingWhitespaces()<CR>
nnoremap <Leader>nh :nohlsearch<CR>
nmap ? /\<\><Left><Left>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :qa!<CR>

inoremap <C-g> <Esc>

noremap <silent> <Left> :bp<CR>
noremap <silent> <Right> :bn<CR>
noremap <silent> <Up> :bdelete<CR>

set pastetoggle=<F9>

" command {{{1
if !(has('win32') || has('win64'))
  command! W w !sudo tee % > /dev/null
endif

" filetype {{{1
autocmd BufWritePost $MYVIMRC source $MYVIMRC
autocmd BufNewFile,BufRead *.vue setf htmldjango

autocmd FileType python set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
autocmd FileType html set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType htmldjango set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType css set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType javascript set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType stylus set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab

" color {{{1
autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTICE\|WARNING\|DANGER\)')

" Find out to which highlight-group a particular keyword/symbol belongs
command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
    \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
    \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
    \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")

" set background=dark
colorscheme torte
set nonumber

" vim:set et sw=2 ts=2 fdm=marker fdl=0:
