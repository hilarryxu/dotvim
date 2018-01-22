" Section: s:env {{{

  if &compatible
    set nocompatible
  endif


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
          \   'dein_path':    user_dir . '/dein',
          \ }

    return env
  endfunction

  let s:env = VimrcEnvironment()

  execute printf("set runtimepath+=%s/repos/github.com/Shougo/dein.vim", s:env.path.dein_path)

" }}}
" Section: dein.vim {{{
  if dein#load_state(s:env.path.dein_path)
    call dein#begin(s:env.path.dein_path)

    call dein#add(s:env.path.dein_path . '/repos/github.com/Shougo/dein.vim')

    call dein#add('hilarryxu/xcc.vim')
    call dein#add('hilarryxu/tag-preview.vim')

    call dein#add('lifepillar/vim-mucomplete')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('eugen0329/vim-esearch')

    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-scriptease')
    call dein#add('tpope/vim-projectionist')

    call dein#add('junegunn/vim-easy-align')

    call dein#add('justinmk/vim-sneak')

    call dein#add('cocopon/vaffle.vim', { 'on_cmd': 'Vaffle' })
    call dein#add('majutsushi/tagbar')
    call dein#add('mbbill/undotree')
    call dein#add('neomake/neomake')
    call dein#add('t9md/vim-quickhl')

    " python

    " golang
    call dein#add('fatih/vim-go', { 'on_ft': 'go' })

    " colorscheme
    call dein#add('cocopon/iceberg.vim')

    call dein#end()
    call dein#save_state()
  endif

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

" }}}
" Section: Functions {{{

  function! s:mkdir_if_needed(dir) abort
    if isdirectory(a:dir)
      return 0
    endif

    call mkdir(a:dir, 'p')
    return 1
  endfunction

  function! s:remove_trailingspace() abort
    let l:winview = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:winview)
    redraw  " See :h :echo-redraw
    echomsg "Trailing space removed!"
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
        execute "set <M-".a:key.">=\e".a:key
      else
        execute "set <M-".a:key.">=\e]{0}".a:key."~"
      endif
    endfunction

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
  endfunction

  function! Xcc_PrevWindowCursor(mode) abort
    if winnr('$') <= 1
      return
    endif

    noautocmd silent! wincmd p
    if a:mode == 0
      execute "normal! \<C-y>"
    elseif a:mode == 1
      execute "normal! \<C-e>"
    elseif a:mode == 2
      execute "normal! " . winheight('.') . "\<C-y>"
    elseif a:mode == 3
      execute "normal! " . winheight('.') . "\<C-e>"
    elseif a:mode == 4
      normal! gg
    elseif a:mode == 5
      normal! G
    elseif a:mode == 6
      execute "normal! \<C-u>"
    elseif a:mode == 7
      execute "normal! \<C-d>"
    elseif a:mode == 8
      execute "normal! k"
    elseif a:mode == 9
      execute "normal! j"
    endif
    noautocmd silent! wincmd p
  endfunction

  function! Xcc_QuickfixCursor(mode) abort
    function! s:quickfix_cursor(mode)
      if &buftype == 'quickfix'
        if a:mode == 0
          execute "normal! \<C-y>"
        elseif a:mode == 1
          execute "normal! \<C-e>"
        elseif a:mode == 2
          execute "normal! " . winheight('.') . "\<C-y>"
        elseif a:mode == 3
          execute "normal! " . winheight('.') . "\<C-e>"
        elseif a:mode == 4
          normal! gg
        elseif a:mode == 5
          normal! G
        elseif a:mode == 6
          execute "normal! \<C-u>"
        elseif a:mode == 7
          execute "normal! \<C-d>"
        elseif a:mode == 8
          execute "normal! k"
        elseif a:mode == 9
          execute "normal! j"
        endif
      endif
    endfunction

    let l:winnr = winnr()
    noautocmd silent! windo call s:quickfix_cursor(a:mode)
    noautocmd silent! execute '' . l:winnr . 'wincmd w'
  endfunction

" }}}
" Section: Settings {{{

  call s:mkdir_if_needed(s:env.path.tmp)
  call s:mkdir_if_needed(s:env.path.undo)

  let mapleader = ","
  let maplocalleader = "\\"

  set hidden
  set notitle
  set showcmd
  set showmatch
  set nowrap
  set nonumber
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
  set splitright
  set splitbelow

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
    let g:ctrlp_map = '<C-p>'
    let g:ctrlp_cmd = 'CtrlP'
    if executable('rg')
      let g:ctrlp_user_command = 'rg %s --files --maxdepth=10 --color=never'
      let g:ctrlp_use_caching = 0
    endif

    let g:ctrlp_custom_ignore = {
          \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
          \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
          \ }
    let g:ctrlp_working_path_mode = 0
    let g:ctrlp_match_window_bottom = 1
    let g:ctrlp_max_height = 15
    let g:ctrlp_match_window_reversed = 0
    let g:ctrlp_mruf_max = 500
    let g:ctrlp_follow_symlinks = 1
  " }}}
  " MUcomplete {{{
    inoremap <expr> <C-e> mucomplete#popup_exit("\<C-e>")
    inoremap <expr> <C-y> mucomplete#popup_exit("\<C-y>")
    inoremap <expr> <CR> mucomplete#popup_exit("\<CR>")
    nnoremap <silent> <Leader>oa :<c-u>MUcompleteAutoToggle<CR>
  " }}}
  " Vaffle {{{
    nnoremap <silent> <Leader>d :<C-u>Vaffle<CR>
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
    noremap <silent> <Leader>vt :<C-u>TagbarToggle<CR>

    let g:tagbar_left = 1
    let g:tagbar_width = 28
    let g:tagbar_autofocus = 1
    " let g:tagbar_iconchars = ['▸', '▾']
  " }}}
 " vim-quickhl {{{
    nmap <Space>m <Plug>(quickhl-manual-this)
    xmap <Space>m <Plug>(quickhl-manual-this)
    nmap <Space>M <Plug>(quickhl-manual-reset)
    xmap <Space>M <Plug>(quickhl-manual-reset)
 " }}}
 " GoldenView {{{
   " let g:goldenview__enable_default_mapping = 0
   " nmap <silent> <Space>s <Plug>GoldenViewSwitchMain
   " nmap <silent> <Space>S <Plug>GoldenViewSwitchToggle
 " }}}
 " vim-go {{{
   let g:go_highlight_functions = 1
   let g:go_highlight_methods = 1
   let g:go_highlight_types = 1
   let g:go_highlight_operators = 1
   let g:go_highlight_build_constraints = 1

   let g:go_fmt_command = 'goimports'
 " }}}
 " Neomake {{{
   call neomake#configure#automake('rw', 2000)
 " }}}

" }}}
" Section: Commands {{{

  " Pack manager
  command! PackUpdate source $MYVIMRC | call dein#update()
  command! PackClean  source $MYVIMRC | echo dein#check_clean()

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
" Section: Maps {{{

  " Set Alt as Meta key
  call Xcc_SetMetaMode(0)
  noremap <M-x> :echo "ALT-X pressed"<CR>
  noremap <Esc>x :echo "ESC-X pressed"<CR>

  " Let's vim
  nnoremap <Up> <Nop>
  nnoremap <Down> <Nop>
  nnoremap <Left> <Nop>
  nnoremap <Right> <Nop>
  inoremap <Up> <Nop>
  inoremap <Down> <Nop>
  inoremap <Left> <Nop>
  inoremap <Right> <Nop>
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
    " nnoremap <silent> <M-h> :<C-u>call xcc#tmux#navigate('h')<CR>
    " nnoremap <silent> <M-j> :<C-u>call xcc#tmux#navigate('j')<CR>
    " nnoremap <silent> <M-k> :<C-u>call xcc#tmux#navigate('k')<CR>
    " nnoremap <silent> <M-l> :<C-u>call xcc#tmux#navigate('l')<CR>
  else
    nnoremap <M-l> <C-w>l
    nnoremap <M-h> <C-w>h
    nnoremap <M-j> <C-w>j
    nnoremap <M-k> <C-w>k
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

  " Leader stuff
  nnoremap <silent> <Leader>m :<C-u>update<CR>:silent make<BAR>redraw!<BAR>bo cwindow<CR>
  nnoremap <silent> <Leader><Space> :nohlsearch<CR>

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
  nnoremap          <Leader>bb :<C-u>ls<CR>:b<Space>
  nnoremap <silent> <Leader>bd :<C-u>call xcc#buffer#keep_window_bd()<CR>
  nnoremap <silent> <Leader>bm :<C-u>CmdBuffer messages<CR>
  nnoremap <silent> <Leader>bn :<C-u>enew<CR>
  nnoremap <silent> <Leader>bs :<C-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<CR>
  nnoremap <silent> <Leader>br :<C-u>setlocal readonly!<CR>
  nnoremap <silent> <Leader>bw :<C-u>bw<CR>
  nnoremap <silent> <Leader>bW :<C-u>bw!<CR>

  " Square bracket mappings (many of them inspired by Unimpaired)
  nnoremap <silent> [<Space> :<C-u>put!=repeat(nr2char(10),v:count1)<CR>']+1
  nnoremap <silent> ]<Space> :<C-u>put=repeat(nr2char(10),v:count1)<CR>'[-1
  nnoremap <silent> [a :<C-u><C-r>=v:count1<CR>prev<CR>
  nnoremap <silent> ]a :<C-u><C-r>=v:count1<CR>next<CR>
  nnoremap <silent> ]b :<C-u><C-r>=v:count1<CR>bn<CR>
  nnoremap <silent> [b :<C-u><C-r>=v:count1<CR>bp<CR>
  nnoremap <silent> ]l :<C-u><C-r>=v:count1<CR>lnext<CR>zz
  nnoremap <silent> [l :<C-u><C-r>=v:count1<CR>lprevious<CR>zz
  nnoremap <silent> ]L :<C-u>llast<CR>zz
  nnoremap <silent> [L :<C-u>lfirst<CR>zz
  nnoremap <silent> ]n :<C-u><C-r>=v:count1<CR>/\v^[<\|=>]{7}<CR>
  nnoremap <silent> [n :<C-u><C-r>=v:count1<CR>?\v^[<\|=>]{7}<CR>
  nnoremap <silent> ]q :<C-u><C-r>=v:count1<CR>cnext<CR>zz
  nnoremap <silent> [q :<C-u><C-r>=v:count1<CR>cprevious<CR>zz
  nnoremap <silent> ]Q :<C-u>clast<CR>zz
  nnoremap <silent> [Q :<C-u>cfirst<CR>zz
  nnoremap <silent> ]t :<C-u><C-r>=v:count1<CR>tn<CR>
  nnoremap <silent> [t :<C-u><C-r>=v:count1<CR>tp<CR>

  " Edit
  nnoremap <silent> <Leader>es :<C-u>call <SID>remove_trailingspace()<CR>
  vnoremap <silent> <Leader>eU :<C-u>s/\%V\v<(.)(\w*)/\u\1\L\2/g<CR>
  inoremap <expr> ) strpart(getline('.'), col('.') - 1, 1) ==# ')' ? "\<Right>" :  ')'
  inoremap <expr> ] strpart(getline('.'), col('.') - 1, 1) ==# ']' ? "\<Right>" :  ']'
  inoremap <expr> } strpart(getline('.'), col('.') - 1, 1) ==# '}' ? "\<Right>" :  '}'

  " Options
  nnoremap <silent> <Leader>op :<C-u>call <SID>toggle_paste()<CR>
  nnoremap <silent> <Leader>oh :<C-u>set hlsearch! \| set hlsearch?<CR>
  nnoremap <silent> <Leader>oi :<C-u>set ignorecase! \| set ignorecase?<CR>
  nnoremap <silent> <Leader>ol :<C-u>setlocal list!<CR>
  nnoremap <silent> <Leader>on :<C-u>setlocal number!<CR>
  nnoremap <silent> <Leader>or :<C-u>setlocal relativenumber!<CR>
  nnoremap <silent> <Leader>ot :<C-u>setlocal expandtab!<CR>

  " Appeareance (view)
  nnoremap <silent> <Leader>vm :<C-u>marks<CR>
  nnoremap <silent> <Leader>vs :<C-u>let &laststatus=2-&laststatus<CR>
  nnoremap <silent> <Leader>vq :<C-u>call xcc#quickfix#toggle(6)<CR>

" }}}
" Section: Autocmds {{{

  augroup vimrc_filetype
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
    autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 cinoptions=:0
    autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nolist
  augroup END

" }}}
" Section: Local settings {{{

  if filereadable(s:env.path.local_vimrc)
    execute 'source ' . s:env.path.local_vimrc
  else
    colorscheme iceberg
  endif

" }}}
