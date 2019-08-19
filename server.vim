" .vimrc
"
" Author:   Larry Xu <hilarryxu@gmail.com>
" Updated:  2019/07/19
"
" This file changes a lot.

" Section: prem {{{1
scriptencoding utf-8

" if &compatible
"   set nocompatible
" endif

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

" config {{{1
let mapleader = ','
let maplocalleader = "\\"
set nomodeline
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
set foldlevelstart=99
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

function! s:capture(excmd) abort
  if exists('*execute')
    return execute(a:excmd)
  else
    try
      redir => cout
      execute 'silent! ' . a:excmd
    finally
      redir END
    endtry
    return cout
  endif
endfunction

if exists('*systemlist')
  function! s:systemlist(cmd, ...) abort
    if type(a:cmd) == 3
      let cmd = map(a:cmd, 'shellescape(v:val)')
      let excmd = join(cmd, ' ')
      return a:0 == 0 ? systemlist(excmd) : systemlist(excmd, a:1)
    else
      return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
    endif
  endfunction
else
  function! s:systemlist(cmd, ...) abort
    if type(a:cmd) == 3
      let cmd = map(a:cmd, 'shellescape(v:val)')
      let excmd = join(cmd, ' ')
      return a:0 == 0 ? split(system(excmd), "\n")
            \ : split(system(excmd, a:1), "\n")
    else
      return a:0 == 0 ? split(system(a:cmd), "\n")
            \ : split(system(a:cmd, a:1), "\n")
    endif
  endfunction
endif

fun! s:get_ff_output(inpath, outpath, callback, channel, status)
  let l:output = filereadable(a:outpath) ? readfile(a:outpath) : []
  silent! call delete(a:outpath)
  silent! call delete(a:inpath)
  call function(a:callback)(l:output)
endf

for s:ff_bin in ['fzy', 'sk', 'fzf', 'selecta', 'pick', ''] " Sort according to your preference
  if executable(s:ff_bin)
    break
  endif
endfor

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
  call append(0, split(s:capture(a:cmd), "\n"))
  normal! gg
endfunction

function! V_cmd(cmd, ...) abort
  let opt = get(a:000, 0, {})
  if !has_key(opt, 'cwd')
    let opt['cwd'] = fnameescape(expand('%:p:h'))
  endif
  let cmd = join(map(a:cmd, 'v:val !~# "\\v^[%#<]" || expand(v:val) ==# "" ? v:val : shellescape(expand(v:val))'))
  execute get(opt, 'pos', 'botright') 'new'
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <buffer> q <c-w>c
  execute 'lcd' opt['cwd']
  execute '%!' cmd
endfunction

function! V_fuzzy(input, callback, prompt) abort
  if empty(s:ff_bin)
    return
  endif

  let l:ff_cmds = {
        \ 'fzf':     "|fzf -m --height 15 --prompt '".a:prompt."> ' 2>/dev/tty",
        \ 'fzy':     "|fzy --lines=15 --prompt='".a:prompt."> ' 2>/dev/tty",
        \ 'pick':    '|pick -X',
        \ 'selecta': '|selecta 2>/dev/tty',
        \ 'sk':      "|sk -m --height 15 --prompt '".a:prompt."> '"
        \ }

  let l:ff_cmd = l:ff_cmds[s:ff_bin]

  if type(a:input) ==# 1  " v:t_string
    let l:inpath = ''
    let l:cmd = a:input . l:ff_cmd
  else  " Assume List
    let l:inpath = tempname()
    call writefile(a:input, l:inpath)
    let l:cmd  = 'cat '.fnameescape(l:inpath) . l:ff_cmd
  endif

  if !has('gui_running') && executable('tput') && filereadable('/dev/tty')
    let l:output = s:systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; ' . l:cmd, &lines))
    redraw!
    silent! call delete(l:inpath)
    call function(a:callback)(l:output)
    return
  endif

  let l:outpath = tempname()
  let l:cmd .= ' >' . fnameescape(l:outpath)

  if has('terminal')
    botright 15split
    call term_start([&shell, &shellcmdflag, l:cmd], {
          \ 'term_name': a:prompt,
          \ 'curwin': 1,
          \ 'term_finish': 'close',
          \ 'exit_cb': function('s:get_ff_output', [l:inpath, l:outpath, a:callback])
          \ })
  else
   silent execute '!' . l:cmd
   redraw!
   call s:get_ff_output(l:inpath, l:outpath, a:callback, -1, v:shell_error)
  endif
endfunction

function! s:set_arglist(paths) abort
  if empty(a:paths) | return | endif
  execute 'args' join(map(a:paths, 'fnameescape(v:val)'))
endfunction

function! V_arglist_fuzzy(input_cmd) abort
  call V_fuzzy(a:input_cmd, 's:set_arglist', 'Choose files')
endfunction

function! V_findfile(...) abort
  let l:dir = (a:0 > 0 ? ' '.a:1 : ' .')
  call V_arglist_fuzzy(executable('rg') ? 'rg --files'.l:dir : 'find'.l:dir.' -type f')
endfunction

function! V_buffer_only() abort
  let bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > bl[0] ? 'confirm '.bl[0].',.-bd' : '') (bufnr('') < bl[-1] ? '|confirm .+,$bd' : '')
endfunction

function! s:set_colorscheme(colors) abort
  execute 'colorscheme' a:colors[0]
endfunction

let s:colors = []

function! V_choose_colorscheme() abort
  if empty(s:colors)
    let s:colors = map(globpath(&runtimepath, "colors/*.vim", 0, 1) , 'fnamemodify(v:val, ":t:r")')
  endif
  call V_fuzzy(s:colors, 's:set_colorscheme', 'Choose colorscheme')
endfunction

function! NilStripTrailingWhitespaces()
  let _s=@/
  let l = line('.')
  let c = col('.')
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

function! NilTogglePaste()
  if (&paste == 1)
    set nopaste
    echo 'Paste: nopaste'
  else
    set paste
    echo 'Paste: paste'
  endif
endfunction

function! NilToggleBackground()
  if &background ==# 'light'
    set background=dark
  else
    set background=light
  endif
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
nnoremap <silent> <Leader>ff :<C-u>FindFile<CR>
nnoremap <Leader>fb :<C-u>ls<CR>:buffer<Space>
nnoremap <silent> <Leader>fr :<C-u>call V_arglist_fuzzy(v:oldfiles)<CR>

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
nnoremap <silent> <Leader>bo :<C-u>call V_buffer_only()<CR>

" option
nnoremap <silent> <Leader>op :call NilTogglePaste()<CR>
nnoremap <silent> <Leader>ob :call NilToggleBackground()<CR>
nnoremap <silent> <Leader>on :<C-u>setlocal number!<CR>

" view
nnoremap <silent> <Leader>vc :<C-u>call V_choose_colorscheme()<CR>
nnoremap <silent> <Leader>vm :<C-u>marks<CR>
nnoremap <silent> <Leader>vr :<C-u>registers<CR>
nnoremap <silent> <Leader>vs :<C-u>let &laststatus=2-&laststatus<CR>
nnoremap <silent> <Leader>vl :<C-u>botright lopen<CR>
nnoremap <silent> <Leader>vq :<C-u>botright copen<CR>

" stuff
map <silent> <leader>ee :e $HOME/_vimrc<cr>
nnoremap <silent> <Leader>ss :call NilStripTrailingWhitespaces()<CR>
nnoremap <Leader>nh :nohlsearch<CR>
" nmap ? /\<\><Left><Left>
" nnoremap <Leader>q :q<CR>
" nnoremap <Leader>Q :qa!<CR>
nnoremap <silent> cd :<c-u>cd %:h \| pwd<cr>
inoremap <C-g> <Esc>
vnoremap < <gv
vnoremap > >gv
noremap <C-g> 2<C-g>
nnoremap gQ <Nop>

" noremap <silent> <Left> :bp<CR>
" noremap <silent> <Right> :bn<CR>
" noremap <silent> <Up> :bdelete<CR>

set pastetoggle=<F9>

" Section: commands {{{1
if !(has('win32') || has('win64'))
  command! W w !sudo tee % > /dev/null
endif

command! -nargs=1 Search call V_search_in_buffer(<q-args>)
command! -nargs=* -complete=file Grep call V_grep(<q-args>)
command! -nargs=? -complete=dir FindFile call V_findfile(<q-args>)

command! -complete=command -nargs=+ VimCmd call V_vim_cmd(<q-args>)

" Section: autocmds {{{1
augroup vimrc_autocmds
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
        \   exe "normal! g`\"" |
        \ endif
  autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTICE\|WARNING\|DANGER\)')
augroup END

augroup vimrc_filetype
  autocmd!
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
augroup END

" color {{{1
" Find out to which highlight-group a particular keyword/symbol belongs
command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
    \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
    \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
    \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")

colorscheme torte

" vim:set et sw=2 ts=2 fdm=marker fdl=0:
