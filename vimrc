" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fcs=vert\:| fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" - To override the settings of a color scheme, create a file
"   after/colors/<theme name>.vim It will be automatically loaded after the
"   color scheme is activated.
" }}
" Environment {{
  set nocompatible " Must be first line

  set rtp+=~/.fzf

  set encoding=utf-8
  scriptencoding utf-8
  set nobomb
  set fileformats=unix,mac,dos
  if has('langmap') && exists('+langremap') | set nolangremap | endif
  set ttimeout
  set ttimeoutlen=10  " This must be a low value for <esc>-key not to be confused with an <a-…> mapping
  set ttyfast
  set mouse=a
  set updatetime=1000 " Trigger CursorHold event after one second

  syntax enable
  filetype on " Enable file type detection
  filetype plugin on " Enable loading the plugin files for specific file types
  filetype indent on " Load indent files for specific file types

  set sessionoptions-=options " See FAQ at https://github.com/tpope/vim-pathogen
  set autoread " Re-read file if it is changed by an external program
  set hidden " Allow buffer switching without saving
  set history=10000 " Keep a longer history (10000 is the maximum)

  " Consolidate temporary files in a central spot
  set backupdir=~/.vim/tmp/backup
  set directory=~/.vim/tmp/swap
  set undofile " Enable persistent undo
  set undodir=~/.vim/tmp/undo
  set undolevels=1000 " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number of lines to save for undo on a buffer reload
" }}
" Plugins {{
  " Disabled Vim Plugins {{
    let g:loaded_getscriptPlugin = 1
    let g:loaded_gzip = 1
    let g:loaded_logiPat = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_tarPlugin = 1
    " let g:loaded_vimballPlugin = 1
    let g:loaded_zipPlugin = 1
  " }}
  " Dirvish {{
    nmap <leader>d <plug>(dirvish_up)
    nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
  " }}
  " Easy Align {{
    xmap <leader>ea <plug>(EasyAlign)
    nmap <leader>ea <plug>(EasyAlign)
  " }}
  " Markdown (Vim) {{
    let g:markdown_fenced_languages = ['pgsql', 'sql']
    let g:markdown_folding = 1
  " }}
  " MUcomplete {{
    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    inoremap <expr> <cr> mucomplete#popup_exit("\<cr>")
    nnoremap <silent> <leader>oa :<c-u>MUcompleteAutoToggle<cr>
  " }}
  " Show Marks {{
    fun! s:toggleShowMarks()
      if exists('b:showmarks')
        NoShowMarks
      else
        DoShowMarks
      endif
    endf
    nnoremap <silent> <leader>vm :<c-u>call <sid>toggleShowMarks()<cr>
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
    nnoremap <silent> <leader>vu :<c-u>if !exists("g:loaded_undotree")<bar>packadd undotree<bar>endif<cr>:UndotreeToggle<cr>
  " }}
  " 2HTML (Vim) {{
    let g:html_pre_wrap = 1
    let g:html_use_encoding = 'UTF-8'
    let g:html_font = ['Consolas', 'Menlo']
  " }}
" }}
" Themes {{
  " Gruvbox {{
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_italic = 1
  " }}
  " Seoul256 {{
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
  " }}
  " Solarized 8 {{
    let g:solarized_statusline = 'low'
    let g:solarized_term_italics = 1
  " }}
  " WWDC16 {{
    let g:wwdc16_term_italics = 1
    let g:wwdc16_term_trans_bg = 1
  " }}
  " WWDC17 {{
    let g:wwdc17_term_italics = 1
  " }}
" }}
" Init {{
  if !has('packages') " Use Pathogen as a fallback
    runtime pack/bundle/opt/pathogen/autoload/pathogen.vim " Load Pathogen
    let g:pathogen_blacklist = ['tagbar', 'undotree']
    execute pathogen#infect('pack/bundle/start/{}', 'pack/my/start/{}', 'pack/my/opt/{}', 'pack/bundle/opt/{}', 'pack/themes/opt/{}')
  endif

  " Local settings
  let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
  if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
  else
    colorscheme seoul256
  endif
" }}
