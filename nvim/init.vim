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

" Colorschemas
Plug 'junegunn/seoul256.vim'
" Override configs by directory 
Plug 'arielrossanigo/dir-configs-override.vim'
" Better file browser
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Class/module browser
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Zen coding
Plug 'mattn/emmet-vim', { 'for': ['html', 'xhtml', 'xml'] }
" Better language packs
Plug 'sheerun/vim-polyglot'
" Lightline
Plug 'itchyny/lightline.vim'
" Window chooser
Plug 't9md/vim-choosewin'
" Autoclose pairs
Plug 'itchyny/vim-parenmatch'
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
" Linters
Plug 'neomake/neomake'
" Show register
Plug 'junegunn/vim-peekaboo'
" Underlines word under cursor
Plug 'itchyny/vim-cursorword'
" Relative numbering of lines (0 is the current line)
Plug 'myusuf3/numbers.vim'
" Pending tasks list
Plug 'fisadev/FixedTaskList.vim'

" Denite
Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
Plug 'rafi/vim-denite-z'

" FZF
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Complete stuff
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next'
    \ }
Plug 'roxma/nvim-completion-manager'

" Plug 'ap/vim-buftabline'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'fatih/vim-go'

" Python
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'fisadev/vim-isort', {'for': 'python'}
Plug 'hdima/python-syntax', {'for': 'python'}

call plug#end()

if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  PlugInstall
endif

" General {{{1
" Basic
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
" --- lsp
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['pyls'],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Functions {{{1
" Commands {{{1
" Maps {{{1

" Autocmds {{{1
autocmd FileType python setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4

autocmd FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>
autocmd FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>

" Custom {{{1

" vim:set sw=2 ts=2 sts=2 et tw=78
