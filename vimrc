" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fcs=vert\:| fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" - To override the settings of a color scheme, create a file
"   after/colors/<theme name>.vim It will be automatically loaded after the
"   color scheme is activated.
" }}
" Environment {{
  set nocompatible " Must be first line

  " vim-sensible {{
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
  " }}

  " The vim is from https://github.com/koron/vim-kaoriya
  let s:is_windows = has('win32') || has('win64')
  let $DOTVIM = expand('~/.vim')

  set hidden " Allow buffer switching without saving

  " Encoding and FileFormat
  set encoding=utf-8
  set fileencodings=utf-8,gbk,chinese,cp936,gb18030,utf-16le,utf-16,big5,euc-jp,euc-kr,latin-1
  set fileencoding=utf-8
  set ffs=unix,dos,mac
  set ff=unix

  " Consolidate temporary files in a central spot
  set backup
  set writebackup
  set backupdir=~/.vim/tmp
  set backupext=.bak
  set noswapfile
  set noundofile
  try
    silent call mkdir(expand('~/.vim/tmp'), 'p', 0755)
  catch /^Vim\%((\a\+)\)\=:E/
  finally
  endtry
" }}
" Editing {{
  " New buffer position
  set splitright " When splitting vertically, focus goes to the right window
  set splitbelow " When splitting horizontally, focus goes to the bottom window
  " Tab
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
" }}
" Find, replace, and completion {{
  set hlsearch " Highlight search results
  set incsearch " Search as you type
  set noignorecase " Case-sensitive search by default
  set keywordprg=:help " Get help for word under cursor by pressing K
  " Grep
  if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    let s:grep_cmd = 'rg --no-heading --vimgrep'
  elseif executable('ag')
    set grepprg=ag\ --vimgrep
    let s:grep_cmd = 'ag --vimgrep'
  endif
  set grepformat^=%f:%l:%c:%m
  " Complete
  set shortmess+=c " Shut off completion messages
  set belloff+=ctrlg " If Vim beeps during completion
  " set complete+=i      " Use included files for completion
  " set complete+=kspell " Use spell dictionary for completion, if available
  set completeopt-=preview
  set completeopt+=menuone,noinsert,noselect
  " Files and directories to ignore
  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  set wildmenu " Show possible matches when autocompleting
  set wildignorecase " Ignore case when completing file names and directories
" }}
" Appearance {{
  set notitle " Do not set the terminal title
  set number " Turn line numbering on
  set relativenumber " Display line numbers relative to the line with the cursor
  set laststatus=2 " Always show status line
  set showcmd " Show (partial) command in the last line of the screen
  " Wrap
  set nowrap " Don't wrap lines by default
  " Fold
  set foldmethod=marker
  " GUI
  if has('gui_running')
    set guioptions-=T
    " set guioptions-=m
    set guioptions-=L
    " set guioptions-=r
    set guioptions-=b
    set mouse=a
    set cursorline
    " set cursorcolumn
    if s:is_windows
      set guifont=Consolas_for_Powerline_FixedD:h11:cANSI
      if has('packages')
        set packpath^=~/.vim
        set packpath+=~/.vim/after
      endif
      set rtp^=~/.vim
      set rtp+=~/.vim/after
    endif
  endif
" }}
" Status line {{
  set statusline=%t\ %m\ %r\ [%{&fileencoding},%{&ff}%Y]\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]
" }}
" Helper functions {{
  function! Xcc_StripTrailingWhitespaces()
    let _s=@/
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
  endfunction

  function! Xcc_TogglePaste()
    if (&paste == 1)
      set nopaste
      echo "Paste: nopaste"
    else
      set paste
      echo "Paste: paste"
    endif
  endfunction

  function! Xcc_PrevWindowCursor(mode)
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

  function! Xcc_QuickfixCursor(mode)
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

  function! Xcc_GrepCode(regex)
    silent execute 'AsyncRun! ' . s:grep_cmd . ' "' . a:regex . '"'
  endfunction

  function! s:GrepOperator(type)
      let saved_unnamed_register = @@

      if a:type ==# 'v'
          normal! `<v`>y
      elseif a:type ==# 'char'
          normal! `[v`]y
      else
          return
      endif

      call Xcc_GrepCode(@@)

      let @@ = saved_unnamed_register
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
" }}
" Commands (plugins excluded) {{
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
" }}
" Key mappings (plugins excluded) {{
  call Xcc_SetMetaMode(0)

  let mapleader = ","
  let maplocalleader = "\\"
  nnoremap ; :

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
  vnoremap < <gv
  vnoremap > >gv
  nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>

  " Inser pairs
  inoremap <C-x>( ()<Esc>i
  inoremap <C-x>9 ()<Esc>i
  inoremap <C-x>[ []<Esc>i
  inoremap <C-x>' ''<Esc>i
  inoremap <C-x>" ""<Esc>i
  inoremap <C-x>< <><Esc>i
  inoremap <C-x>{ {<Esc>o}<Esc>ko

  " Windows
  if $TERM =~# '^\%(tmux\|screen\)'
    nnoremap <silent> <M-h> :<C-u>call xcc#tmux#navigate('h')<CR>
    nnoremap <silent> <M-j> :<C-u>call xcc#tmux#navigate('j')<CR>
    nnoremap <silent> <M-k> :<C-u>call xcc#tmux#navigate('k')<CR>
    nnoremap <silent> <M-l> :<C-u>call xcc#tmux#navigate('l')<CR>
  else
    nnoremap <M-l> <C-w>l
    nnoremap <M-h> <C-w>h
    nnoremap <M-j> <C-w>j
    nnoremap <M-k> <C-w>k
  endif

  " Cursor
  nnoremap <silent> <M-u> :call Xcc_PrevWindowCursor(6)<CR>
  nnoremap <silent> <M-d> :call Xcc_PrevWindowCursor(7)<CR>

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
  nnoremap <Space>bn :call xcc#buffer#navigate('bn')<CR>
  nnoremap <Space>bp :call xcc#buffer#navigate('bp')<CR>
  nnoremap <Space>bf :bfirst<CR>
  nnoremap <Space>bl :blast<CR>
  nnoremap <space>bd :call xcc#buffer#keep_window_bd()<CR>
  noremap <silent> <Left> :call xcc#buffer#navigate('bp')<CR>
  noremap <silent> <Right> :call xcc#buffer#navigate('bn')<CR>
  noremap <silent> <Up> :call xcc#buffer#keep_window_bd()<CR>
  noremap <silent> <Down> :call xcc#buffer#to_alternate_edit_buf()<CR>
  for i in range(1, 9)
    execute 'nnoremap <silent> <Space>' . i . ' :b ' . i . '<CR>'
  endfor

  " Files
  nnoremap <Space>ff :<C-u>FindFile<CR>

  " Goto
  nnoremap <silent> g1 :call Xcc_GrepCode(expand('<cword>'))<CR>

  " Toggle
  nnoremap <silent> <Space>vq :call xcc#quickfix#toggle(6)<CR>

  " Options
  nnoremap <silent> <Space>op :<C-u>call Xcc_TogglePaste()<CR>
  nnoremap <silent> <Space>oh :<C-u>set hlsearch! \| set hlsearch?<CR>
  nnoremap <silent> <Space>oi :<C-u>set ignorecase! \| set ignorecase?<CR>
  nnoremap <silent> <Space>ol :<C-u>setlocal list!<CR>
  nnoremap <silent> <Space>on :<C-u>setlocal number!<CR>
  nnoremap <silent> <Space>or :<C-u>setlocal relativenumber!<CR>
  nnoremap <silent> <Space>ot :<C-u>setlocal expandtab!<CR>

  " xcc_snip
  noremap <Space>s- :call xcc_snip#comment_block('-')<CR>
  noremap <Space>s= :call xcc_snip#comment_block('=')<CR>
  noremap <Space>sc :call xcc_snip#copyright('Larry Xu')<CR>
  noremap <Space>sm :call xcc_snip#main()<CR>
  noremap <Space>st "=strftime("%Y/%m/%d %H:%M:%S")<CR>gp

  " <Leader>
  nnoremap <silent> <Leader>g :set operatorfunc=<SID>GrepOperator<CR>g@
  vnoremap <silent> <Leader>g :<C-u>call <SID>GrepOperator(visualmode())<CR>

" }}
" Plugins {{
  " Disabled Vim Plugins {{
    let g:loaded_getscriptPlugin = 1
    let g:loaded_gzip = 1
    let g:loaded_logiPat = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_tarPlugin = 1
    let g:loaded_vimballPlugin = 1
    let g:loaded_zipPlugin = 1
  " }}
  " CtrlP | LeaderF {{
    let g:ctrlp_cmd = 'CtrlPBuffer'
    let g:ctrlp_working_path_mode = 'ra'
    if executable('rg')
      let g:ctrlp_user_command = 'rg %s --files --maxdepth=10 --color=never'
      let g:ctrlp_use_caching = 0
    elseif executable('ag')
      let g:ctrlp_user_command = 'ag -g "" %s'
      let g:ctrlp_use_caching = 0
    endif
    let g:user_command_async = 1

    nnoremap <Space>fb :<C-u>CtrlPBuffer<CR>
    nnoremap <Space>fr :<C-u>CtrlPMRUFiles<CR>
    nnoremap <Space>ft :<C-u>CtrlPTag<CR>
    nnoremap <Space>fq :<C-u>:CtrlPQuickfix<CR>
    " nnoremap <Space>fu :<C-u>:CtrlPFunky<CR>
    nnoremap <Space>fu :<C-u>:LeaderfFunky<CR>
  " }}
  " Dirvish {{
    nmap <Space>dd <plug>(dirvish_up)
  " }}
  " Easy Align {{
    xmap <Space>ea <plug>(EasyAlign)
    nmap <Space>ea <plug>(EasyAlign)
  " }}
  " UltiSnip {{
  let g:UltiSnipsExpandTrigger='<C-l>'
  let g:UltiSnipsEditSplit = 'horizontal'
  let g:UltiSnipsSnippetsDir=$HOME.'/.vim/mysnippets'
  let g:UltiSnipsEnableSnipMate = 0
  " }}
  " MUcomplete {{
    let g:mucomplete#no_mappings = 0
    let g:mucomplete#chains = {}
    let g:mucomplete#chains.default = ['keyp']
    let g:mucomplete#chains.vim = ['cmd', 'keyp']
    let g:mucomplete#chains.python = ['keyp', 'tags', 'ulti']
    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    " inoremap <expr> <cr> mucomplete#popup_exit("\<cr>")
    nnoremap <silent> <Space>oa :<C-u>MUcompleteAutoToggle<CR>
  " }}
  " Show Marks {{
    function! Xcc_ToggleShowMarks()
      if exists('b:showmarks')
        NoShowMarks
      else
        DoShowMarks
      endif
    endfunction
    nnoremap <silent> <Space>vm :<C-u>call Xcc_ToggleShowMarks()<CR>
  " }}
  " Sneak {{
    let g:sneak#streak = 1
    " Match according to ignorecase and smartcase
    let g:sneak#use_ic_scs = 1
  " }}
  " Lightline {{
    function! Xcc_LightlineFilename()
      let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
      let modified = &modified ? ' +' : ''
      return filename . modified
    endfunction

    let g:lightline = {
          \ 'colorscheme': 'seoul256',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'gitbranch', 'readonly', 'filename' ] ],
          \   'right': [ [ 'lineinfo' ],
          \              [ 'percent' ],
          \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ],
          \ },
          \ 'component': {
          \   'charvaluehex': '[%b][0x%B]',
          \ },
          \ 'component_function': {
          \   'gitbranch': 'fugitive#head',
          \   'filename': 'Xcc_LightlineFilename',
          \ },
          \ }
  " }}
  " Goyo and Limelight {{
    function! s:goyo_enter()
      silent !tmux set status off
      silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
      set noshowmode
      set noshowcmd
      set scrolloff=999
      Limelight
    endfunction

    function! s:goyo_leave()
      silent !tmux set status on
      silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
      set showmode
      set showcmd
      set scrolloff=5
      Limelight!
    endfunction

    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
  " }}
  " ChooseWin {{
    let g:choosewin_overlay_enable = 1
    nmap - <Plug>(choosewin)
  " }}
  " Tagbar {{
    function! TagbarStatusLine(current, sort, fname, flags, ...) abort
      return (a:current ? '%#NormalMode# Tagbar %* ' : '%#StatusLineNC# Tagbar ') . a:fname
    endfunction

    nnoremap <silent> <Space>vt :<C-u>if !exists("g:loaded_tagbar")<bar>packadd tagbar<bar>endif<CR>:TagbarToggle<CR>
    let g:tagbar_autofocus = 1
    let g:tagbar_iconchars = ['▸', '▾']
    let g:tagbar_status_func = 'TagbarStatusLine'
  " }}
  " Undotree {{
    let g:undotree_WindowLayout = 2
    let g:undotree_SplitWidth = 40
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_TreeNodeShape = '◦'
    nnoremap <silent> <Space>vu :<C-u>if !exists("g:loaded_undotree")<bar>packadd undotree<bar>endif<CR>:UndotreeToggle<CR>
  " }}
  " 2HTML (Vim) {{
    let g:html_pre_wrap = 1
    let g:html_use_encoding = 'UTF-8'
    let g:html_font = ['Consolas', 'Menlo']
  " }}
  " Markdown (Vim) {{
    let g:markdown_folding = 1
  " }}
  " Python (Vim) {{
    let g:python_version_2 = 1
    let g:python_highlight_all = 1
  " }}
" }}
" Themes {{
  " Seoul256 {{
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
  " }}
" }}
" Init {{
  if !has('packages') " Use Pathogen as a fallback
    runtime pack/bundle/opt/pathogen/autoload/pathogen.vim " Load Pathogen
    let g:pathogen_blacklist = ['tagbar', 'undotree']
    execute pathogen#infect('pack/bundle/start/{}', 'pack/my/start/{}', 'pack/my/opt/{}', 'pack/bundle/opt/{}', 'pack/themes/opt/{}')
  endif

  if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
  endif

  " Local settings
  if filereadable($DOTVIM . '/init.vim')
    source $DOTVIM/init.vim
  else
    colorscheme seoul256
  endif

  augroup vimrcEx
    au!
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
    autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 cinoptions=:0

    autocmd User AsyncRunStart call xcc#quickfix#toggle(8, 1)
  augroup END

  " Reload menu
  if has('gui_running')
    let $LANG = 'en'  "set message language  
    set langmenu=en   "set menu's language of gvim. no spaces beside '='
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif
" }}
