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
Plug 'cocopon/iceberg.vim'

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

" Plugin Group: Formater
" Plugin: neoformat
Plug 'sbdchd/neoformat'

" Plugin Group: File browser
" Plugin: Dirvish
Plug 'justinmk/vim-dirvish'
" Better file browser
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

" Plugin Group: Basic plugins
" Override configs by directory 
Plug 'arielrossanigo/dir-configs-override.vim'
" Better language packs
Plug 'sheerun/vim-polyglot'
" Buffer switch
Plug 'bsdelf/bufferhint'
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Class/module browser
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Window chooser
Plug 't9md/vim-choosewin'
" Autoclose pairs
" Plug 'jiangmiao/auto-pairs'
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

" Plugin Group: tpope
" Surround
Plug 'tpope/vim-surround'
" Repeat
Plug 'tpope/vim-repeat'
" Dispatch
Plug 'tpope/vim-dispatch'
" Projectionist
Plug 'tpope/vim-projectionist'

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

" Ignore
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git,*.hg,.hg
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android

" Use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
  let &t_Co = 256
  colorscheme seoul256
else
  colorscheme torte
endif

" Plugin configs {{{1
" Plugin: Denite {{{2
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

" Plugin: Airline {{{2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'iceberg'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#fnamemod = ':t'
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

nmap <Space>1 <Plug>AirlineSelectTab1
nmap <Space>2 <Plug>AirlineSelectTab2
nmap <Space>3 <Plug>AirlineSelectTab3
nmap <Space>4 <Plug>AirlineSelectTab4
nmap <Space>5 <Plug>AirlineSelectTab5
nmap <Space>6 <Plug>AirlineSelectTab6
nmap <Space>7 <Plug>AirlineSelectTab7
nmap <Space>8 <Plug>AirlineSelectTab8
nmap <Space>9 <Plug>AirlineSelectTab9

" Plugin: Ultisnips {{{2
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

" Plugin: Neomake {{{2
call neomake#configure#automake('rw', 1000)

" Plugin: Tagbar {{{2
let g:tagbar_left = 1
let g:tagbar_width = 28
nnoremap <silent> <F2> :TagbarToggle<CR>

" Plugin: BufferHint {{{2
nnoremap - :call bufferhint#Popup()<CR>
nnoremap <Leader>pp :call bufferhint#LoadPrevious()<CR>

let g:bufferhint_CustomHighlight = 1
hi! default link KeyHint Statement
hi! default link AtHint Identifier

" Plugin: Dirvish {{{2
nmap <Leader>dd <plug>(dirvish_up)

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

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

" Maps {{{1
" Let's vim
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Visual shifting
vnoremap < <gv
vnoremap > >gv

" Navigate into console error messages
nmap <F5> :cnext<CR>
nmap <F6> :cprev<CR>

" Replace all of current word
nnoremap <Leader>ss :%s/\<<C-r><C-w>\>//g<Left><Left>

" Search with grep
nnoremap <Leader>/ :Ag<Space>
nnoremap g1 :Ag <C-r><C-w><CR>

" Yank and replace
noremap <Space>y yiw
noremap <Space>r viw"0p

" color syntax info
map <Space><F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
	    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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
  au FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
  au FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2
  au FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
  au FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4

  au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  au FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>
  au FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>

  au FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab list
augroup END

" Custom {{{1

" vim:set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker
