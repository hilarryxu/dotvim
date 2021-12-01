" .vimrc
"
" Author:   Larry Xu <hilarryxu@gmail.com>
" Updated:  2021/11/30
"
" This file changes a lot.

" Section: prem {{{1
if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8

function! VimrcEnvironment()
  let env = {}
  let env.is_mac = has('mac')
  let env.is_linux = has('unix') && !has('macunix') && !has('win32unix')
  let env.is_win = has('win32') || has('win64')
  let env.is_cygwin = !empty($MINTTY_SHORTCUT) || !empty($MSYSTEM)

  let env.nvim = has('nvim') && exists('*jobwait') && !env.is_win
  let env.vim8 = exists('*job_start')
  let env.timer = exists('*timer_start')
  let env.tmux = !empty($TMUX)
  let env.gui = has('gui_running')
  let env.win_gvim = env.is_win && has('gui_running')
  let env.has_python = has('python') || has('python3')

  let user_dir = (env.is_win && !env.is_cygwin)
        \ ? expand('$VIM/vimfiles')
        \ : expand('~/.vim')
  if env.win_gvim
    let user_dir = expand('~/.vim')
  endif
  let env.path = {
        \   'user':        user_dir,
        \   'plugins':     user_dir . '/plugins',
        \   'data':        user_dir . '/data',
        \   'local_vimrc': user_dir . '/.vimrc_local',
        \   'tmp':         user_dir . '/tmp',
        \   'undo':        user_dir . '/data/undo',
        \   'plug_path':   user_dir . '/plugged',
        \ }

  return env
endfunction

let s:env = VimrcEnvironment()
let $VIMHOME = s:env.path.user
let g:vimrc_env = s:env

if s:env.nvim || s:env.win_gvim
  set runtimepath^=$HOME/.vim
  set runtimepath+=$HOME/.vim/after
endif

if has('gui_running')
  let $LANG = 'en'
  set langmenu=en
  set guioptions-=T
  set guioptions-=r
  set guioptions-=b
  set mouse=a
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

" if &encoding ==# 'latin1' && has('gui_running')
"   set encoding=utf-8
" endif

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

" Section: config {{{1
let mapleader = ','
let maplocalleader = "\\"
set modeline

set hidden
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
" set showtabline=2
" set cmdheight=2

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
set foldlevelstart=99
nnoremap z0 zCz0

" search
set showmatch
set matchtime=2
set matchpairs+=<:>
set incsearch
set hlsearch
set ignorecase
set smartcase

" backup
set nobackup
set nowritebackup
set noswapfile

" statusline
set laststatus=2
set list listchars=tab:\|\ ,trail:.
set stl=%t\ %m\ %r\ [%{&fileencoding},%{&ff}%Y]\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

" encoding
" set langmenu=zh_CN.UTF-8
" set encoding=utf-8
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
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/nginx_runtime/*,*/build/*,*/logs/*

" Section: plugins {{{1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_spellfile_plugin = 1

" Section: functions {{{1
function! s:warn(error) abort
  echohl WarningMsg
  echomsg a:error
  echohl None
endfunction

function! Local_set_colorscheme(colors) abort
  execute 'colorscheme' a:colors[0]
endfunction

let s:colors = []

function! V_choose_colorscheme() abort
  if empty(s:colors)
    let s:colors = map(globpath(&runtimepath, 'colors/*.vim', 0, 1) , 'fnamemodify(v:val, ":t:r")')
  endif
  call local#search#fuzzy(s:colors, 'Local_set_colorscheme', 'Choose colorscheme')
endfunction

function! V_strip_trailing_whitespaces() abort
  let winview = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(winview)
  redraw
  echomsg 'Trailing space removed!'
endfunction

function! V_toggle_paste()
  if (&paste == 1)
    set nopaste
    echo 'Paste: nopaste'
  else
    set paste
    echo 'Paste: paste'
  endif
endfunction

function! V_toggle_background()
  if &background ==# 'light'
    set background=dark
  else
    set background=light
  endif
endfunction

" Find in quickfix/location list
function! s:jump_to_qf_entry(items) abort
  execute 'crewind' matchstr(a:items[0], '^\s*\d\+', '')
endfunction

function! s:jump_to_loclist_entry(items) abort
  execute 'lrewind' matchstr(a:items[0], '^\s*\d\+', '')
endfunction

function! s:find_in_qflist() abort
  let qflist = getqflist()
  if empty(qflist)
    call s:warn('Quickfix list is empty')
    return
  endif
  call local#search#fuzzy(split(execute('clist'), "\n"), 's:jump_to_qf_entry', 'Filter quickfix entry')
endfunction

function! s:find_in_loclist(winnr) abort
  let loclist = getloclist(a:winnr)
  if empty(loclist)
    call s:warn('Location list is empty')
    return
  endif
  call local#search#fuzzy(split(execute('llist'), "\n"), 's:jump_to_loclist_entry', 'Filter loclist entry')
endfunction

" Section: mappings {{{1
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

" <Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>\<C-y>" : "\<Tab>"
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"
endfunction

" find/filter
nnoremap <silent> <C-p> :<C-u>FindFile<CR>
nnoremap <silent> <Leader>ff :<C-u>FindFile<CR>
" nnoremap <Leader>fb :<C-u>ls<CR>:buffer<Space>
nnoremap <silent> - :<C-u>call local#search#choose_buffer({})<CR>
nnoremap <silent> <Leader>fb :<C-u>call local#search#choose_buffer({})<CR>
nnoremap <silent> <Leader>fr :<C-u>call local#search#fuzzy_arglist(v:oldfiles)<CR>
nnoremap <silent> <Leader>fl :<C-u>call <SID>find_in_loclist(0)<CR>
nnoremap <silent> <Leader>fq :<C-u>call <SID>find_in_qflist()<CR>

" tab
nnoremap <Leader>an :tabn<CR>
nnoremap <Leader>ap :tabp<CR>
nnoremap <Leader>am :tabm
nnoremap <Leader>at :tabnew
nnoremap <Leader>as :tab split<CR>

" window
nnoremap <Leader>1 1<C-w>w
nnoremap <Leader>2 2<C-w>w
nnoremap <Leader>3 3<C-w>w
nnoremap <Leader>4 4<C-w>w
nnoremap <Leader>5 5<C-w>w
nnoremap <Leader>6 6<C-w>w
nnoremap <Leader>7 7<C-w>w
nnoremap <Leader>8 8<C-w>w
nnoremap <Leader>9 9<C-w>w
nnoremap <Leader>0 10<C-w>w

" buffer
nnoremap <silent> <Leader>ba :<C-u>call xcc#tags#alt_file()<CR>
nnoremap <silent> <Leader>bd :<C-u>bd<CR>
nnoremap <silent> <Leader>bc :<C-u>call local#buffer#safe_close()<CR>
nnoremap <silent> <Leader>bo :<C-u>call local#buffer#delete_others()<CR>
nnoremap <silent> <Leader>bm :<C-u>VimCmd messages<CR>
nnoremap <silent> <Leader>bn :<C-u>enew<CR>
nnoremap <silent> <Leader>bs :<C-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<CR>
nnoremap <silent> <Leader>br :<C-u>setlocal readonly!<CR>

" square bracket
nnoremap <silent> [<space> :<c-u>put!=repeat(nr2char(10),v:count1)<cr>']+1
nnoremap <silent> ]<space> :<c-u>put=repeat(nr2char(10),v:count1)<cr>'[-1
nnoremap <silent> [a :<c-u><c-r>=v:count1<cr>prev<cr>
nnoremap <silent> ]a :<c-u><c-r>=v:count1<cr>next<cr>
nnoremap <silent> ]b :<c-u><c-r>=v:count1<cr>bn<cr>
nnoremap <silent> [b :<c-u><c-r>=v:count1<cr>bp<cr>
nnoremap <silent> ]l :<c-u><c-r>=v:count1<cr>lnext<cr>zz
nnoremap <silent> [l :<c-u><c-r>=v:count1<cr>lprevious<cr>zz
nnoremap <silent> ]L :<c-u>llast<cr>zz
nnoremap <silent> [L :<c-u>lfirst<cr>zz
nnoremap <silent> ]n /\v^[<\|=>]{7}<cr>
nnoremap <silent> [n ?\v^[<\|=>]{7}<cr>
nnoremap <silent> ]q :<c-u><c-r>=v:count1<cr>cnext<cr>zz
nnoremap <silent> [q :<c-u><c-r>=v:count1<cr>cprevious<cr>zz
nnoremap <silent> ]Q :<c-u>clast<cr>zz
nnoremap <silent> [Q :<c-u>cfirst<cr>zz
nnoremap <silent> ]t :<c-u><c-r>=v:count1<cr>tn<cr>
nnoremap <silent> [t :<c-u><c-r>=v:count1<cr>tp<cr>

" copy & paste
nnoremap <Leader>y "xy
vnoremap <Leader>y "xy
nnoremap <Leader>Y "xY
vnoremap <Leader>Y "xY
nnoremap <Leader>p "xp
vnoremap <Leader>p "xp
nnoremap <Leader>P "xP
vnoremap <Leader>P "xP

" git
nnoremap <silent> <Leader>gd :<C-u>call local#git#diff()<CR>
nnoremap <silent> <Leader>gs :<C-u>call local#run#cmd(['git', 'status'])<CR>

" option
nnoremap <silent> <Leader>op :call V_toggle_paste()<CR>
nnoremap <silent> <Leader>ob :call V_toggle_background()<CR>
nnoremap <silent> <Leader>on :<C-u>setlocal number!<CR>

" view
nnoremap <silent> <Leader>vc :<C-u>call V_choose_colorscheme()<CR>
nnoremap <silent> <Leader>vm :<C-u>marks<CR>
nnoremap <silent> <Leader>vr :<C-u>registers<CR>
nnoremap <silent> <Leader>vs :<C-u>let &laststatus=2-&laststatus<CR>
nnoremap <silent> <Leader>vl :<C-u>botright lopen<CR>
nnoremap <silent> <Leader>vq :<C-u>botright copen<CR>
nnoremap <silent> <Leader>vz :<C-u>call local#win#zoom_toggle()<CR>

" edit
nnoremap <silent> <Leader>ee :e $HOME/.vim/_vimrc<CR>
nnoremap <silent> <Leader>es :call V_strip_trailing_whitespaces()<CR>

" insert pair
inoremap <C-x>( ()<Esc>i
inoremap <C-x>9 ()<Esc>i
inoremap <C-x>[ []<Esc>i
inoremap <C-x>' ''<Esc>i
inoremap <C-x>" ""<Esc>i
inoremap <C-x>< <><Esc>i
inoremap <C-x>{ {<Esc>o}<Esc>ko

" other stuff
set pastetoggle=<F9>
nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>
nnoremap <Leader>nh :nohlsearch<CR>
" nmap ? /\<\><Left><Left>
" nnoremap <Leader>q :q<CR>
" nnoremap <Leader>Q :qa!<CR>
inoremap <C-g> <Esc>
vnoremap < <gv
vnoremap > >gv
noremap <C-g> 2<C-g>
nnoremap gQ <Nop>

" Section: commands {{{1
if !s:env.is_win
  command! W w !sudo tee % > /dev/null
endif

" Find out to which highlight-group a particular keyword/symbol belongs
command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
    \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
    \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
    \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")

command! -nargs=1 Search call local#search#cur_buffer(<q-args>)
command! -nargs=* -complete=file Grep call local#search#grep(<q-args>)
command! -nargs=? -complete=dir FindFile call local#search#fuzzy_files(<q-args>)

command! -complete=command -nargs=+ VimCmd call local#run#vim_cmd(<q-args>)

command! -nargs=? TabWidth call local#text#tab_width(<args>)

" Section: autocmds {{{1
augroup vimrc_autocmds
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
        \   exe "normal! g`\"" |
        \ endif
  autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTE\|NOTICE\|WARNING\|DANGER\)')
augroup END

augroup vimrc_filetype
  autocmd!
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
augroup END

" Section: local_vimrc {{{1
if filereadable(s:env.path.local_vimrc)
  execute 'source ' . s:env.path.local_vimrc
else
  colorscheme torte
endif

if has('gui_running') && s:env.is_win
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" vim:set et sw=2 ts=2 fdm=marker fdl=0:
