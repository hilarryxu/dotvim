" Pre settings {{{1
let g:language_group = ['python', 'c', 'go', 'markdown', 'html', 'css', 'js']

" Plugins {{{1
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
  echo "Installing Vim-plug..."
  echo ""
  silent !mkdir -p ~/.config/nvim/autoload
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let vim_plug_just_installed = 1
endif

if vim_plug_just_installed
  execute 'source ' . fnameescape(vim_plug_path)
endif

call plug#begin('~/.config/nvim/plugged')

" Plugin Group: Colorscheme
Plug 'junegunn/seoul256.vim'

" Plugin Group: Statusbar
" Plugin: vim-airline
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

" Plugin Group: Search
" Plugin: denite
Plug 'nixprime/cpsm'
Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
Plug 'rafi/vim-denite-z'

" Plugin: fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Plugin Group: Autocomplete
" Plugin: LSP
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next'
    \ }

" Plugin: ncm
Plug 'roxma/nvim-completion-manager'

" Plugin Group: Syntax checker
" Plugin: neomake
Plug 'neomake/neomake'

" Plugin Group: Basic plugins
" Override configs by directory 
Plug 'arielrossanigo/dir-configs-override.vim'
" Better language packs
Plug 'sheerun/vim-polyglot'
" Better file browser
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Class/module browser
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Window chooser
Plug 't9md/vim-choosewin'
" Autoclose pairs
" Plug 'jiangmiao/auto-pairs'
" Surround
Plug 'tpope/vim-surround'
" Repeat
Plug 'tpope/vim-repeat'
" Sneak jump
Plug 'justinmk/vim-sneak'
" Easy align
Plug 'junegunn/vim-easy-align'
" Snippets
Plug 'honza/vim-snippets' | Plug 'SirVer/ultisnips'
" Show register
Plug 'junegunn/vim-peekaboo'
" Underlines word under cursor
Plug 'itchyny/vim-cursorword'
" Pending tasks list
Plug 'fisadev/FixedTaskList.vim'

" Plugin Group: Others
" Plug 'ap/vim-buftabline'
" Plug 'ludovicchabant/vim-gutentags'

" Plugin Group: Plugins for language
" Plugin: python
if count(g:language_group, 'python')
  Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
  Plug 'fisadev/vim-isort', { 'for': 'python' }
  Plug 'hdima/python-syntax', { 'for': 'python' }
endif

" Plugin: go
if count(g:language_group, 'go')
  " Plug 'fatih/vim-go'
endif

" Pluign: markdown
if count(g:language_group, 'markdown')
  Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
endif

" Plugin: html
if count(g:language_group, 'html')
  Plug 'mattn/emmet-vim', { 'for': ['html', 'xhtml', 'xml'] }
  Plug 'docunext/closetag.vim'
endif

call plug#end()

if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  PlugInstall
endif


" General settings {{{1
let mapleader = ","
set hidden

" No backup files
set nobackup
set nowritebackup
set noswapfile

" Tabs and spaces
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
  let &t_Co = 256
  colorscheme seoul256
else
  colorscheme torte
endif

" Plugin configs {{{1
" Plugin: denite {{{2
call denite#custom#option('default', 'prompt', '> ')
"call denite#custom#option('default', 'direction', 'bottom')
call denite#custom#option('default', 'empty', 0)
call denite#custom#option('default', 'auto_resize', 1)

" Change file_rec command.
call denite#custom#var('file_rec', 'command',
  \ ['ag', '--depth', '10', '--follow', '--nocolor', '--nogroup', '-g', ''])
" buffer
call denite#custom#var('buffer', 'date_format', '')

" Change grep options.
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
  \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Change file_rec matcher
call denite#custom#source('file_rec,redis_mru', 'matchers', ['matcher_cpsm'])
call denite#custom#source('line', 'matchers', ['matcher_regexp'])
" Sorter of file_rec
call denite#custom#source('file_rec,outline,redis_mru,note', 'sorters', ['sorter_rank'])

" Change mappings.
call denite#custom#map(
      \ 'insert',
      \ '<C-a>',
      \ '<denite:move_caret_to_head>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-s>',
      \ '<denite:do_action:vsplit>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-t>',
      \ '<denite:do_action:tabopen>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-d>',
      \ '<denite:do_action:delete>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-b>',
      \ '<denite:scroll_page_backwards>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-f>',
      \ '<denite:scroll_page_forwards>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-p>',
      \ '<denite:print_messages>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ '<esc>',
      \ '<denite:quit>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'a',
      \ '<denite:do_action:add>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'd',
      \ '<denite:do_action:delete>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'r',
      \ '<denite:do_action:reset>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 's',
      \ '<denite:do_action:vsplit>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'e',
      \ '<denite:do_action:edit>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'h',
      \ '<denite:do_action:help>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'u',
      \ '<denite:do_action:update>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'f',
      \ '<denite:do_action:find>',
      \ 'noremap'
      \)

nnoremap <silent> <Space>p  :<C-u>Denite -resume<CR>
nnoremap <silent> <Space>j  :call execute('Denite -resume -select=+'.v:count1.' -immediately')<CR>
nnoremap <silent> <Space>k  :call execute('Denite -resume -select=-'.v:count1.' -immediately')<CR>

nnoremap <silent> <Space>f  :<C-u>Denite file_rec<CR>
nnoremap <silent> <Space>b  :<C-u>Denite buffer<CR>
nnoremap <silent> <Space>w  :<C-u>DeniteCursorWord -auto-resize line<CR>

" Plugin: NERDTree {{{2
"let NERDTreeChDirMode = 2
"let NERDTreeShowHidden = 1
"let NERDTreeQuitOnOpen = 1
"let NERDTreeShowLineNumbers = 1
"nnoremap <F3> :NERDTreeToggle<CR>

" Pluin: airline {{{2
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Plugin: ultisnips {{{2
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsEditSplit = 'vertical'

" Plugin: LSP {{{2
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ 'python': ['pyls'],
      \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F12> :call LanguageClient_textDocument_rename()<CR>

" Plugin: neomake {{{2
call neomake#configure#automake('rw', 1000)

" Plugin: tagbar {{{2
let g:tagbar_left = 1
let g:tagbar_width = 28
nnoremap <silent> <F2> :TagbarToggle<CR>

" Functions {{{1
" Simple clean utility
function! s:Clean()
  let view = winsaveview()
  let ft = &filetype
  " replace tab with 2 space
  if index(['javascript', 'html', 'css', 'vim'], ft) != -1
    silent! execute "%s/\<tab>/  /g"
  endif
  " replace tab with 2 space
  if index(['python'], ft) != -1
    silent! execute "%s/\<tab>/    /g"
  endif
  " replace tailing comma
  if ft ==# 'javascript'
    silent! execute '%s/;$//'
    " line should not starts with [ or (
    silent! execute '%s/^\s*\zs\([\[(]\)/;\1/'
  endif
  " remove tailing white space
  silent! execute '%s/\s\+$//'
  " remove windows
  silent! execute '%s/$//'
  call winrestview(view)
endfunction

" Commands {{{1
" :W to save file by sudo
command W w !sudo tee % > /dev/null

" Maps {{{1
nnoremap <Leader>e :e <C-R>=substitute(expand('%:p:h').'/', getcwd().'/', '', '')<CR>
nnoremap <Leader>v :vs <C-R>=substitute(expand('%:p:h').'/', getcwd().'/', '', '')<CR>
nnoremap <Leader>t :tabe <C-R>=substitute(expand('%:p:h').'/', getcwd().'/', '', '')<CR>
" Replace all of current word
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
" Search with grep
nnoremap <Leader>/ :Ag<space>
" clean some dirty charactors
nnoremap <silent> <Leader>cl :<C-u>call <SID>Clean()<CR>
" Buffer
nnoremap H :bp<CR>
nnoremap L :bn<CR>
nnoremap <Leader>bq :bp <BAR> bd #<CR>

" Setting switch
nnoremap <Leader>hc :let @/ = ""<CR>
nnoremap <Leader>pt :set paste!<CR>

" Autocmds {{{1
augroup vimrcFileType
  au!
  au FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 foldmethod=marker
  au FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
  au FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2
  au FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
  au FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4

  au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  au FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>
  au FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>
augroup END

" Custom {{{1

" vim:set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker
