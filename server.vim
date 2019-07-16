" .vimrc
"
" Author:   Larry Xu <hilarryxu@gmail.com>
" Updated:  2019/07/16
"
" This file changes a lot.

" Section: prem {{{1
scriptencoding utf-8

if &compatible
  set nocompatible
endif

" Section: sensible {{{1
if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set incsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set laststatus=2
set ruler
set wildmenu

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has('patch541')
  " Delete comment character when joining commented lines
  set formatoptions+=j
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

" Re-read file if it is changed by an external program
set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>

" config {{{1
let mapleader = ","
let maplocalleader = "\\"
nnoremap ; :

set nonumber
set backspace=indent,eol,start
set history=1000
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set updatetime=200
set ruler
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

" grep
if executable('rg')
  set grepprg=rg\ -i\ --vimgrep
endif
set grepformat^=%f:%l:%c:%m

" wildignore
set wildignore+=*.pyc,*.sqlite,*.sqlite3,cscope.out
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/nginx_runtime/*,*/build/*,*/logs/*

" plugin {{{1

" Section: functions {{{1
function! s:warn(error) abort
  echohl WarningMsg
  echomsg a:error
  echohl None
endfunction

function! V_search_in_buffer(pattern) abort
  if getbufvar(winbufnr(winnr()), '&ft') ==# 'qf'
    call s:warn('Cannot search the quickfix window')
    return
  endif
  try
    silent noautocmd execute 'lvimgrep /' . a:pattern . '/gj ' . fnameescape(expand('%'))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call s:warn('No match')
  endtry
  bo lwindow
endfunction

function! V_grep(args) abort
  execute 'silent grep!' a:args
  bo cwindow
  redraw!
endfunction

function! V_vim_cmd(cmd) abort
  botright 10new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, split(execute(a:cmd), "\n"))
  normal gg
endfunction

function! V_cmd(cmd, ...) abort
  let opt = get(a:000, 0, {})
  if !has_key(opt, 'cwd')
    let opt['cwd'] = fnameescape(expand('%:p:h'))
  endif
  let cmd = join(map(a:cmd, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  execute get(opt, 'pos', 'botright') 'new'
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <buffer> q <c-w>c
  execute 'lcd' opt['cwd']
  execute '%!' cmd
endfunction

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

" Section: mapping {{{1
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

" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

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
" nmap ? /\<\><Left><Left>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :qa!<CR>
nnoremap <silent> cd :<c-u>cd %:h \| pwd<cr>

inoremap <C-g> <Esc>

noremap <silent> <Left> :bp<CR>
noremap <silent> <Right> :bn<CR>
noremap <silent> <Up> :bdelete<CR>

set pastetoggle=<F9>

" Section: command {{{1
if !(has('win32') || has('win64'))
  command! W w !sudo tee % > /dev/null
endif

command! -nargs=1 Search call V_search_in_buffer(<q-args>)
command! -nargs=* -complete=file Grep call V_grep(<q-args>)

command! -complete=command -nargs=+ VimCmd call V_vim_cmd(<q-args>)

" Section: autocmd {{{1
autocmd BufWritePost $MYVIMRC source $MYVIMRC

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

colorscheme torte

" vim:set et sw=2 ts=2 fdm=marker fdl=0: