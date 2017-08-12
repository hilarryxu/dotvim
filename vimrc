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
  set splitright " When splitting vertically, focus goes to the right window
  set splitbelow " When splitting horizontally, focus goes to the bottom window
  " Tab
  set expandtab " Use soft tabs by default
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
" }}
" Find, replace, and completion {{
  set hlsearch " Highlight search results
  set incsearch " Search as you type
  set noignorecase " Case-sensitive search by default
  set infercase " Smart case when doing keyword completion
  set smartcase " Use case-sensitive search if there is a capital letter in the search expression
  set keywordprg=:help " Get help for word under cursor by pressing K
  " Grep
  if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
  elseif executable('ag')
    set grepprg=ag\ --vimgrep
  endif
  set grepformat^=%f:%l:%c:%m
  " Complete
  " set complete+=i      " Use included files for completion
  " set complete+=kspell " Use spell dictionary for completion, if available
  set completeopt+=menuone,noselect
  set completeopt-=preview
  " Files and directories to ignore
  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  set wildmenu " Show possible matches when autocompleting
  set wildignorecase " Ignore case when completing file names and directories
  " Cscope
  set cscoperelative
  set cscopequickfix=s-,c-,d-,i-,t-,e-
  if has('patch-7.4.2033') | set cscopequickfix+=a- | endif
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
    set guioptions-=m
    set guioptions-=L
    set guioptions-=r
    set guioptions-=b
    set showtabline=2 " Always show the tab bar
    set cursorline
    " set cursorcolumn
    if s:is_windows
      set guifont=Consolas_for_Powerline_FixedD:h10:cANSI
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
" Tab line {{
  if !exists('g:config_vim_gui_label')
    let g:config_vim_tab_style = 0
  endif

  " make tabline in terminal mode
  function! Vim_NeatTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " select the highlighting
      if i + 1 == tabpagenr()
        let s .= '%#TabLineSel#'
      else
        let s .= '%#TabLine#'
      endif

      " set the tab page number (for mouse clicks)
      let s .= '%' . (i + 1) . 'T'

      " the label is made by MyTabLabel()
      let s .= ' %{Vim_NeatTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      let s .= '%=%#TabLine#%999XX'
    endif

    return s
  endfunc

  " get a single tab name
  function! Vim_NeatBuffer(bufnr, fullname)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
      if l:name == ''
        return '[No Name]'
      else
        if a:fullname
          return fnamemodify(l:name, ':p')
        else
          return fnamemodify(l:name, ':t')
        endif
      endif
    else
      let l:buftype = getbufvar(a:bufnr, '&buftype')
      if l:buftype == 'quickfix'
        return '[Quickfix]'
      elseif l:name != ''
        if a:fullname
          return '-'.fnamemodify(l:name, ':p')
        else
          return '-'.fnamemodify(l:name, ':t')
        endif
      else
      endif
      return '[No Name]'
    endif
  endfunc

  " get a single tab label
  function! Vim_NeatTabLabel(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    let l:fname = Vim_NeatBuffer(l:bufnr, 0)
    let l:num = a:n
    if g:config_vim_tab_style == 0
      return l:fname
    elseif g:config_vim_tab_style == 1
      return "[".l:num."] ".l:fname
    elseif g:config_vim_tab_style == 2
      return "".l:num." - ".l:fname
    endif
    if getbufvar(l:bufnr, '&modified')
      return "[".l:num."] ".l:fname." +"
    endif
    return "[".l:num."] ".l:fname
  endfunc

  set tabline=%!Vim_NeatTabLine()
" }}
" Helper functions {{
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
      echo "Paste: nopaste"
    else
      set paste
      echo "Paste: paste"
    endif
  endfunction
" }}
" Commands (plugins excluded) {{
  " Load vim-shortcut
  runtime pack/bundle/opt/vim-shortcut/plugin/shortcut.vim " Load vim-shortcut

  " Execute a Vim command and send the output to a new scratch buffer
  command! -complete=command -nargs=+ CmdBuffer call xcc_buffer#cmd(<q-args>)

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
  let mapleader = ","
  let maplocalleader = "\\"
  nnoremap ; :

  " call xcc_terminal#meta_mode(0)
  set pastetoggle=<f9>

  " Let's vim
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
 
  Shortcut show shortcut menu and run chosen shortcut
    \ noremap <silent> <Leader><Leader> :Shortcuts<CR>

  Shortcut change to the directory of the current file
    \ nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>

  " Inser pairs
  inoremap <c-x>( ()<esc>i
  inoremap <c-x>[ []<esc>i
  inoremap <c-x>' ''<esc>i
  inoremap <c-x>" ""<esc>i
  inoremap <c-x>< <><esc>i
  inoremap <c-x>{ {<esc>o}<esc>ko

  " Tabs
  " call xcc_terminal#alt_map_tab()
  Shortcut go to next tab
    \ nnoremap <silent> <Space>tn :tabn<CR>
  Shortcut go to prev tab
    \ nnoremap <silent> <Space>tp :tabp<CR>
  Shortcut new tab
    \ nnoremap <Space>tt :tabnew
  Shortcut close current tab
    \ nnoremap <silent> <Space>tc :tabclose<CR>
  for i in range(1, 9)
    execute 'Shortcut go to tab number '. i .' '
      \ 'nnoremap <silent> <Leader>'. i .' :tabn '. i .'<CR>'
  endfor

  " Windows

  " Buffers
  Shortcut go to next buffer
    \ nnoremap <Space>bn :bnext<CR>
  Shortcut go to prev buffer
    \ nnoremap <Space>bp :bprevious<CR>
  Shortcut go to first buffer
    \ nnoremap <Space>bf :bfirst<CR>
  Shortcut go to last buffer
    \ nnoremap <Space>bl :blast<CR>
  Shortcut delete current buffer
    \ nnoremap <space>bd :bd<CR>
  nnoremap <space>bk :bw<CR>
  noremap <silent> <Left> :bp<CR>
  noremap <silent> <Right> :bn<CR>
  noremap <silent> <Up> :bdelete<CR>

  " Files
  Shortcut Sudo save current buffer
    \ nnoremap <Space>fW :<C-u>w !sudo tee % >/dev/null<CR>

  " Options
  Shortcut toggle option paste
    \ nnoremap <silent> <Space>op :<C-u>call NilTogglePaste()<CR>
  Shortcut toggle option hlsearch
    \ nnoremap <silent> <Space>oh :<C-u>set hlsearch! \| set hlsearch?<CR>
  Shortcut toggle option ignorecase
    \ nnoremap <silent> <Space>oi :<C-u>set ignorecase! \| set ignorecase?<CR>
  Shortcut toggle option list
    \ nnoremap <silent> <Space>ol :<C-u>setlocal list!<CR>
  Shortcut toggle option number
    \ nnoremap <silent> <Space>on :<C-u>setlocal number!<CR>
  Shortcut toggle option relativenumber
    \ nnoremap <silent> <Space>or :<C-u>setlocal relativenumber!<CR>
  Shortcut toggle option expandtab
    \ nnoremap <silent> <Space>ot :<C-u>setlocal expandtab!<CR>

  " xcc_snip
  Shortcut (xcc_snip) comment block -
    \ noremap <Space>s- :call xcc_snip#comment_block('-')<CR>
  Shortcut (xcc_snip) comment block =
    \ noremap <Space>s= :call xcc_snip#comment_block('=')<CR>
  Shortcut (xcc_snip) copyright
    \ noremap <Space>sc :call xcc_snip#copyright('Larry Xu')<CR>
  Shortcut (xcc_snip) main
    \ noremap <Space>sm :call xcc_snip#main()<CR>
  Shortcut (xcc_snip) current datetime
    \ noremap <Space>st "=strftime("%Y/%m/%d %H:%M:%S")<CR>gp
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
  " FZF {{
    set rtp+=~/.fzf
    Shortcut (fzf) open file in/under working directory
      \ nnoremap <silent> <Space>ff :Files<CR>
    Shortcut (fzf) open file relative to current file
      \ nnoremap <silent> <Space>fc :execute 'Files' expand('%:h')<CR>
    Shortcut (fzf) open file in git repository
      \ nnoremap <silent> <Space>fg :GFiles<CR>
    Shortcut (fzf) open file in git status
      \ nnoremap <silent> <Space>fG :GFiles?<CR>
    Shortcut (fzf) open buffer
      \ nnoremap <silent> <Space>fb :Buffers<CR>
    Shortcut (fzf) search in files under working directory
      \ nnoremap <silent> <Space>fa :Ag<Space>
    Shortcut (fzf) go to line in any buffer
      \ nnoremap <silent> <Space>'L :Lines<CR>
    Shortcut (fzf) go to line in buffer
      \ nnoremap <silent> <Space>'l :BLines<CR>
    Shortcut (fzf) go to ctag in any buffer
      \ nnoremap <silent> <Space>'] :Tags<CR>
    Shortcut (fzf) go to ctags in buffer
      \ nnoremap <silent> <Space>'[ :Tags<CR>
    Shortcut (fzf) go to mark in buffer
      \ nnoremap <silent> <Space>'m :Marks<CR>
    Shortcut (fzf) go to window
      \ nnoremap <silent> <Space>'w :Windows<CR>
    Shortcut (fzf) run command
      \ nnoremap <silent> <Space>:: :Commands<CR>
    Shortcut (fzf) run mapping
      \ nnoremap <silent> <Space>eM :Maps<CR>
    Shortcut (fzf) apply filetype
      \ nnoremap <silent> <Space>:f :Filetypes<CR>
  " }}
  " Dirvish {{
    Shortcut (dirvish) open dirvish
      \ nmap <Space>dd <plug>(dirvish_up)
  " }}
  " Easy Align {{
    xmap <Leader>ea <plug>(EasyAlign)
    nmap <Leader>ea <plug>(EasyAlign)
  " }}
  " Markdown (Vim) {{
    let g:markdown_folding = 1
  " }}
  " MUcomplete {{
    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    inoremap <expr> <cr> mucomplete#popup_exit("\<cr>")
    nnoremap <silent> <Space>oa :<C-u>MUcompleteAutoToggle<CR>
  " }}
  " Show Marks {{
    function! NilToggleShowMarks()
      if exists('b:showmarks')
        NoShowMarks
      else
        DoShowMarks
      endif
    endfunction
    Shortcut (showmarks) toggle show marks
      \ nnoremap <silent> <Space>vm :<C-u>call NilToggleShowMarks()<CR>
  " }}
  " Sneak {{
    let g:sneak#streak = 1
    let g:sneak#use_ic_scs = 1 " Match according to ignorecase and smartcase
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
    colorscheme zenburn
  endif

  augroup vimrcEx
    au!
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType pug setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab omnifunc=
  augroup END

  " Reload menu
  if has('gui_running')
    let $LANG = 'en'  "set message language  
    set langmenu=en   "set menu's language of gvim. no spaces beside '='
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif
" }}
