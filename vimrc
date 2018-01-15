" Section: s:env {{{
function! VimrcEnvironment()
  let env = {}
  let env.is_mac = has('mac')
  let env.is_win = has('win32') || has('win64')

  let user_dir = env.is_win
        \ ? expand('$VIM/vimfiles')
        \ : expand('~/.vim')
  let env.path = {
        \   'user':        user_dir,
        \   'plugins':     user_dir . '/plugins',
        \   'data':        user_dir . '/data',
        \   'local_vimrc': user_dir . '/.vimrc_local',
        \   'tmp':         user_dir . '/tmp',
        \   'undo':        user_dir . '/data/undo',
        \   'vim_plug':    user_dir . '/vim-plug',
        \ }

  return env
endfunction

let s:env = VimrcEnvironment()
" }}}
" Section: vim-sensible {{{
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

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set autoread " Re-read file if it is changed by an external program

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
" }}}
" Section: Functions {{{
  function! s:mkdir_if_needed(dir) abort
    if isdirectory(a:dir)
      return 0
    endif

    call mkdir(a:dir, 'p')
    return 1
  endfunction

  function! s:minautopac_add(repo, ...) abort
    let l:opts = get(a:000, 0, {})
    if has_key(l:opts, 'for')
      let l:name = substitute(a:repo, '^.*/', '', '')
      let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for
      execute printf('autocmd FileType %s packadd %s', l:ft, l:name)
    endif
  endfunction

  function! s:remove_trailingspace() abort
    let l:winview = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:winview)
    redraw  " See :h :echo-redraw
    echomsg 'Trailing space removed!'
  endfunction

  function! s:toggle_paste() abort
    if (&paste == 1)
      set nopaste
      echo "Paste: nopaste"
    else
      set paste
      echo "Paste: paste"
    endif
  endfunction

  function! Xcc_SetMetaMode(mode) abort
    if has('nvim') || has('gui_running')
      return
    endif

    function! s:metacode(mode, key)
      if a:mode == 0
        exec "set <M-".a:key.">=\e".a:key
      else
        exec "set <M-".a:key.">=\e]{0}".a:key."~"
      endif
    endfunc

    for i in range(10)
      call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
      call s:metacode(a:mode, nr2char(char2nr('a') + i))
      call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor

    if a:mode != 0
      for c in [',', '.', '/', ';', '[', ']', '{', '}']
        call s:metacode(a:mode, c)
      endfor
      for c in ['?', ':', '-', '_']
        call s:metacode(a:mode, c)
      endfor
    else
      for c in [',', '.', '/', ';', '{', '}']
        call s:metacode(a:mode, c)
      endfor
      for c in ['?', ':', '-', '_']
        call s:metacode(a:mode, c)
      endfor
    endif

    if &ttimeout == 0
      set ttimeout
    endif
    if &ttimeoutlen <= 0
      set ttimeoutlen=100
    endif
  endfunction

  function! Xcc_PrevWindowCursor(mode) abort
    if winnr('$') <= 1
      return
    endif
    noautocmd silent! wincmd p
    if a:mode == 0
      exec "normal! \<c-y>"
    elseif a:mode == 1
      exec "normal! \<c-e>"
    elseif a:mode == 2
      exec "normal! " . winheight('.') . "\<c-y>"
    elseif a:mode == 3
      exec "normal! " . winheight('.') . "\<c-e>"
    elseif a:mode == 4
      normal! gg
    elseif a:mode == 5
      normal! G
    elseif a:mode == 6
      exec "normal! \<c-u>"
    elseif a:mode == 7
      exec "normal! \<c-d>"
    elseif a:mode == 8
      exec "normal! k"
    elseif a:mode == 9
      exec "normal! j"
    endif
    noautocmd silent! wincmd p
  endfunction

  function! Xcc_QuickfixCursor(mode) abort
    function! s:quickfix_cursor(mode)
      if &buftype == 'quickfix'
        if a:mode == 0
          exec "normal! \<c-y>"
        elseif a:mode == 1
          exec "normal! \<c-e>"
        elseif a:mode == 2
          exec "normal! " . winheight('.') . "\<c-y>"
        elseif a:mode == 3
          exec "normal! " . winheight('.') . "\<c-e>"
        elseif a:mode == 4
          normal! gg
        elseif a:mode == 5
          normal! G
        elseif a:mode == 6
          exec "normal! \<c-u>"
        elseif a:mode == 7
          exec "normal! \<c-d>"
        elseif a:mode == 8
          exec "normal! k"
        elseif a:mode == 9
          exec "normal! j"
        endif
      endif
    endfunc
    let l:winnr = winnr()
    noautocmd silent! windo call s:quickfix_cursor(a:mode)
    noautocmd silent! execute '' . l:winnr . 'wincmd w'
  endfunction
" }}}
" Section: minpac {{{
silent! packadd minpac
if exists('*minpac#init')
  call minpac#init()

  command! -nargs=+ -bar Plug call minpac#add(<args>) | call s:minautopac_add(<args>)
else
  command! -nargs=+ Plug call s:minautopac_add(<args>)
endif

Plug 'k-takata/minpac', {'type': 'opt'}
Plug 'hilarryxu/xcc.vim'
Plug 'hilarryxu/tag-preview.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lifepillar/vim-mucomplete'
Plug 'lifepillar/vim-cheat40'
Plug 'lifepillar/vim-outlaw'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'cocopon/vaffle.vim', {'type': 'opt'}
Plug 'majutsushi/tagbar', {'type': 'opt'}
Plug 'mbbill/undotree', {'type': 'opt'}
Plug 'neomake/neomake', {'type': 'opt'}

Plug 'cocopon/iceberg.vim', {'type': 'opt'}
Plug 'lifepillar/vim-wwdc16-theme', {'type': 'opt'}
" }}}
" Section: Settings {{{
call s:mkdir_if_needed(s:env.path.tmp)
call s:mkdir_if_needed(s:env.path.undo)

set hidden
set notitle
set showcmd
set showmatch
set nowrap
set number
set statusline=%t\ %m\ %r\ [%{&fileencoding},%{&ff}%Y]\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]
set splitright
set splitbelow
set list
if executable('rg')
  set grepprg=rg\ -i\ --vimgrep
endif
set grepformat^=%f:%l:%c:%m
set completeopt+=menuone,noselect
set completeopt-=preview
set shortmess+=c
set belloff+=ctrlg

set encoding=utf-8
set fileencodings=utf-8,gbk,chinese,cp936,gb18030,utf-16le,utf-16,big5,euc-jp,euc-kr,latin-1
set fileencoding=utf-8
set ffs=unix,dos,mac
set ff=unix

set nobackup
set noswapfile
execute 'set undodir=' . s:env.path.undo
set undofile

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  set wildmenu " Show possible matches when autocompleting
  set wildignorecase " Ignore case when completing file names and directories

  set hlsearch
  set noignorecase
  set incsearch
  set smartcase
  set wrapscan
" }}}
" Section: Plugin configs {{{
  " Disabled vim plugins {{{
  let g:loaded_getscriptPlugin = 1
  let g:loaded_gzip = 1
  let g:loaded_logiPat = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_rrhelper = 1
  let g:loaded_tarPlugin = 1
  let g:loaded_vimballPlugin = 1
  let g:loaded_zipPlugin = 1
  " }}}
  " CtrlP {{{
  let g:ctrlp_map = '<Leader>p'
  let g:ctrlp_cmd = 'CtrlP'
  if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --maxdepth=10 --color=never'
    let g:ctrlp_use_caching = 0
  endif

  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
        \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
        \ }
  let g:ctrlp_working_path_mode=0
  let g:ctrlp_match_window_bottom=1
  let g:ctrlp_max_height=15
  let g:ctrlp_match_window_reversed=0
  let g:ctrlp_mruf_max=500
  let g:ctrlp_follow_symlinks=1
  " }}}
  " MUcomplete {{{
  inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
  inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
  inoremap <expr> <cr> mucomplete#popup_exit("\<cr>")
  nnoremap <silent> <leader>oa :<c-u>MUcompleteAutoToggle<cr>
  " }}}
  " Vaffle {{{
  nnoremap <silent> <leader>d :<c-u>if !exists('g:loaded_vaffle')<bar>packadd vaffle.vim<bar>endif<cr>:Vaffle<cr>
  " }}}
  " EasyAlign {{{
  nmap ga <Plug>(EasyAlign)
  xmap ga <Plug>(EasyAlign)
  " }}}
  " Sneak {{{
  let g:sneak#label = 1
  let g:sneak#use_ic_scs = 1
  " }}}
  " Tagbar {{{
  noremap <silent> <leader>vt :<c-u>if !exists("g:loaded_tagbar")<bar>packadd tagbar<bar>endif<cr>:TagbarToggle<cr>
  let g:tagbar_autofocus = 1
  let g:tagbar_iconchars = ['▸', '▾']
  " }}}
" }}}
" Section: Commands {{{
  " Pack manager
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

  " Find all occurrences of a pattern in the current buffer
  command! -nargs=1 Search call xcc#find#buffer(<q-args>)

  " Find all occurrences of a pattern in all open buffers
  command! -nargs=1 SearchAll call xcc#find#all_buffers(<q-args>)

  " Fuzzy search for files inside a directory (default: working dir).
  command! -nargs=? -complete=dir FindFile call xcc#find#file(<q-args>)

  " Grep code in cwd
  command! -nargs=1 GrepCode call Xcc_GrepCode(<q-args>)

  " Execute an external command and show the output in a new buffer
  command! -complete=shellcmd -nargs=+ Shell call xcc#job#to_buffer(<q-args>, 'B')

  " Execute a Vim command and send the output to a new scratch buffer
  command! -complete=command -nargs=+ CmdBuffer call xcc#buffer#cmd(<q-args>)

  " Send text to a terminal
  command! BindTerminal call xcc#terminal#open()
  command! REPLSendLine call xcc#terminal#send([getline('.')])

  " Sudo write
  if !(has('win32') || has('win64'))
    command! W w !sudo tee % > /dev/null
  endif

  " Find out to which highlight-group a particular keyword/symbol belongs
  command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
      \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
      \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
      \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")
" }}}
" Section: Mappings {{{
  call Xcc_SetMetaMode(1)
  noremap <M-x> :echo "ALT-X pressed"<CR>
  noremap <Esc>x :echo "ESC-X pressed"<CR>

  let mapleader = ","
  let maplocalleader = "\\"

  " Let's vim
  nnoremap <Up> <nop>
  nnoremap <Down> <nop>
  nnoremap <Left> <nop>
  nnoremap <Right> <nop>
  inoremap <Up> <nop>
  inoremap <Down> <nop>
  inoremap <Left> <nop>
  inoremap <Right> <nop>
  inoremap <F1> <ESC>
  nnoremap <F1> <ESC>
  vnoremap <F1> <ESC>

  " Faster command mode
  cnoremap <C-h> <Left>
  cnoremap <C-j> <Down>
  cnoremap <C-k> <Up>
  cnoremap <C-l> <Right>
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-f> <C-d>
  cnoremap <C-b> <Left>
  cnoremap <C-_> <C-k>

  " Some usefull maps
  nnoremap ; :
  noremap j gj
  noremap k gk
  vnoremap < <gv
  vnoremap > >gv
  noremap <C-g> 2<C-g>
  set pastetoggle=<F9>
  nnoremap gQ <Nop>
  nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>

  " Windows
  if $TERM =~# '^\%(tmux\|screen\)'
    nnoremap <silent> <M-h> :<c-u>call xcc#tmux#navigate('h')<cr>
    nnoremap <silent> <M-j> :<c-u>call xcc#tmux#navigate('j')<cr>
    nnoremap <silent> <M-k> :<c-u>call xcc#tmux#navigate('k')<cr>
    nnoremap <silent> <M-l> :<c-u>call xcc#tmux#navigate('l')<cr>
  else
    nnoremap <M-l> <c-w>l
    nnoremap <M-h> <c-w>h
    nnoremap <M-j> <c-w>j
    nnoremap <M-k> <c-w>k
  endif

  " Easy copy/paste
  nnoremap <Leader>y "*y
  vnoremap <Leader>y "*y
  nnoremap <Leader>Y "*Y
  nnoremap <Leader>p "*p
  vnoremap <Leader>p "*p
  nnoremap <Leader>P "*P
  vnoremap <Leader>P "*P

  " Inser pairs
  inoremap <C-x>( ()<Esc>i
  inoremap <C-x>9 ()<Esc>i
  inoremap <C-x>[ []<Esc>i
  inoremap <C-x>' ''<Esc>i
  inoremap <C-x>" ""<Esc>i
  inoremap <C-x>< <><Esc>i
  inoremap <C-x>{ {<Esc>o}<Esc>ko

  " Make
  nnoremap <silent> <Leader>m :<c-u>update<cr>:silent make<bar>redraw!<bar>bo cwindow<cr>

  " Cursor
  nnoremap <silent> <M-[> :call Xcc_QuickfixCursor(2)<CR>
  nnoremap <silent> <M-]> :call Xcc_QuickfixCursor(3)<CR>
  nnoremap <silent> <M-{> :call Xcc_QuickfixCursor(4)<CR>
  nnoremap <silent> <M-}> :call Xcc_QuickfixCursor(5)<CR>
  nnoremap <silent> <M-u> :call Xcc_PrevWindowCursor(6)<CR>
  nnoremap <silent> <M-d> :call Xcc_PrevWindowCursor(7)<CR>

  inoremap <silent> <M-[> <C-\><C-o>:call Xcc_QuickfixCursor(2)<CR>
  inoremap <silent> <M-]> <C-\><C-o>:call Xcc_QuickfixCursor(3)<CR>
  inoremap <silent> <M-{> <C-\><C-o>:call Xcc_QuickfixCursor(4)<CR>
  inoremap <silent> <M-}> <C-\><C-o>:call Xcc_QuickfixCursor(5)<CR>
  inoremap <silent> <M-u> <C-\><C-o>:call Xcc_PrevWindowCursor(6)<CR>
  inoremap <silent> <M-d> <C-\><C-o>:call Xcc_PrevWindowCursor(7)<CR>

  " Buffers
  nnoremap          <Leader>bb :<C-u>ls<cr>:b<space>
  nnoremap <silent> <Leader>bd :<C-u>call xcc#buffer#keep_window_bd()<CR>
  nnoremap <silent> <Leader>bm :<C-u>CmdBuffer messages<cr>
  nnoremap <silent> <Leader>bn :<C-u>enew<cr>
  nnoremap <silent> <Leader>bs :<C-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<cr>
  nnoremap <silent> <Leader>br :<C-u>setlocal readonly!<cr>
  nnoremap <silent> <Leader>bw :<C-u>bw<cr>
  nnoremap <silent> <Leader>bW :<C-u>bw!<cr>

  " Square bracket mappings (many of them inspired by Unimpaired)
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
  nnoremap <silent> ]n :<c-u><c-r>=v:count1<cr>/\v^[<\|=>]{7}<cr>
  nnoremap <silent> [n :<c-u><c-r>=v:count1<cr>?\v^[<\|=>]{7}<cr>
  nnoremap <silent> ]q :<c-u><c-r>=v:count1<cr>cnext<cr>zz
  nnoremap <silent> [q :<c-u><c-r>=v:count1<cr>cprevious<cr>zz
  nnoremap <silent> ]Q :<c-u>clast<cr>zz
  nnoremap <silent> [Q :<c-u>cfirst<cr>zz
  nnoremap <silent> ]t :<c-u><c-r>=v:count1<cr>tn<cr>
  nnoremap <silent> [t :<c-u><c-r>=v:count1<cr>tp<cr>

  " Edit
  nnoremap <silent> <leader>es :<c-u>call <sid>removeTrailingSpace()<cr>
  vnoremap <silent> <leader>eU :<c-u>s/\%V\v<(.)(\w*)/\u\1\L\2/g<cr>
  inoremap <expr> ) strpart(getline('.'), col('.') - 1, 1) ==# ')' ? "\<right>" :  ')'
  inoremap <expr> ] strpart(getline('.'), col('.') - 1, 1) ==# ']' ? "\<right>" :  ']'
  inoremap <expr> } strpart(getline('.'), col('.') - 1, 1) ==# '}' ? "\<right>" :  '}'

  " Options
  nnoremap <silent> <Leader>op :<C-u>call Xcc_TogglePaste()<CR>
  nnoremap <silent> <Leader>oh :<C-u>set hlsearch! \| set hlsearch?<CR>
  nnoremap <silent> <Leader>oi :<C-u>set ignorecase! \| set ignorecase?<CR>
  nnoremap <silent> <Leader>ol :<C-u>setlocal list!<CR>
  nnoremap <silent> <Leader>on :<C-u>setlocal number!<CR>
  nnoremap <silent> <Leader>or :<C-u>setlocal relativenumber!<CR>
  nnoremap <silent> <Leader>ot :<C-u>setlocal expandtab!<CR>

  " Appeareance (view)
  nnoremap <silent> <Leader>vm :<c-u>marks<cr>
  nnoremap <silent> <Leader>vs :<c-u>let &laststatus=2-&laststatus<cr>
  nnoremap <silent> <Leader>vq :<C-u>call xcc#quickfix#toggle(6)<CR>
" }}}
" Section: Autocmds {{{
  augroup vimrc_filetype
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
    autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 cinoptions=:0
    autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

  augroup END
" }}}
" Section: Local settings {{{
if filereadable(s:env.path.local_vimrc)
  execute 'source ' . s:env.path.local_vimrc
else
  colorscheme iceberg
endif
" }}}
