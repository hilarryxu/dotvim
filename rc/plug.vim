let s:env = g:vimrc_env

" Disable vimruntime plugins
let g:loaded_2html_plugin      = 1 "$VIMRUNTIME/plugin/tohtml.vim
let g:loaded_getscript         = 1 "$VIMRUNTIME/autoload/getscript.vim
let g:loaded_getscriptPlugin   = 1 "$VIMRUNTIME/plugin/getscriptPlugin.vim
let g:loaded_gzip              = 1 "$VIMRUNTIME/plugin/gzip.vim
let g:loaded_logipat           = 1 "$VIMRUNTIME/plugin/logiPat.vim
let g:loaded_logiPat           = 1 "$VIMRUNTIME/plugin/logiPat.vim
let g:loaded_matchparen        = 1 "$VIMRUNTIME/plugin/matchparen.vim
let g:loaded_netrw             = 1 "$VIMRUNTIME/autoload/netrw.vim
let g:loaded_netrwFileHandlers = 1 "$VIMRUNTIME/autoload/netrwFileHandlers.vim
let g:loaded_netrwPlugin       = 1 "$VIMRUNTIME/plugin/netrwPlugin.vim
let g:loaded_netrwSettings     = 1 "$VIMRUNTIME/autoload/netrwSettings.vim
let g:loaded_rrhelper          = 1 "$VIMRUNTIME/plugin/rrhelper.vim
let g:loaded_spellfile_plugin  = 1 "$VIMRUNTIME/plugin/spellfile.vim
let g:loaded_sql_completion    = 1 "$VIMRUNTIME/autoload/sqlcomplete.vim
let g:loaded_syntax_completion = 1 "$VIMRUNTIME/autoload/syntaxcomplete.vim
let g:loaded_tar               = 1 "$VIMRUNTIME/autoload/tar.vim
let g:loaded_tarPlugin         = 1 "$VIMRUNTIME/plugin/tarPlugin.vim
let g:loaded_vimball           = 1 "$VIMRUNTIME/autoload/vimball.vim
let g:loaded_vimballPlugin     = 1 "$VIMRUNTIME/plugin/vimballPlugin.vim
let g:loaded_zip               = 1 "$VIMRUNTIME/autoload/zip.vim
let g:loaded_zipPlugin         = 1 "$VIMRUNTIME/plugin/zipPlugin.vim
let g:vimsyn_embed             = 1 "$VIMRUNTIME/syntax/vim.vim

" Enhancement
Plug 'thinca/vim-localrc'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
" Plug 'junegunn/vim-slash'
Plug 't9md/vim-quickhl'
" Plug 'haya14busa/incsearch.vim'
" Plug 'mtth/scratch.vim'
Plug 'itchyny/vim-parenmatch'
Plug 'terryma/vim-expand-region'
" Plug 'terryma/vim-smooth-scroll'
" Plug 'rhysd/clever-f.vim'

" Operator and Textobj
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'

Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
" Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for': ['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
Plug 'bps/vim-textobj-python', { 'for': 'python' }
" Plug 'jceb/vim-textobj-uri'

" File finder
" if s:env.nvim || has('patch-8.1.2114')
"   Plug 'liuchengxu/vim-clap'
" endif
if s:env.has_python
  Plug 'Yggdroot/LeaderF'
endif
Plug 'lifepillar/vim-zeef'

" Coding
Plug 'tpope/vim-commentary'
Plug 'skywind3000/asyncrun.vim'
Plug 'neomake/neomake' | Plug 'tracyone/neomake-multiprocess'
Plug 'sbdchd/neoformat'
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'Shougo/echodoc.vim'
Plug 'hilarryxu/vim-dict'
Plug 'skywind3000/vim-preview'
Plug 'ludovicchabant/vim-gutentags'

" Git
if executable('git')
  Plug 'tpope/vim-fugitive' | Plug 'junegunn/gv.vim'
  Plug 'rhysd/git-messenger.vim'
endif

" Completion
if s:env.nvim
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
elseif s:env.has_python
  Plug 'maralla/completor.vim'
endif

" Snippet
if s:env.nvim
  Plug 'honza/vim-snippets'
endif

" txt
" Plug 'markabe/vim-txt'

" Vim
" Plug 'mhinz/vim-lookup', { 'for': 'vim' }

" Python
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'hilarryxu/vim-bundle-mako', { 'for': 'mako' }

" Go
Plug 'fatih/vim-go'

" Nim
if 0 && s:env.nvim
  Plug 'alaviss/nim.nvim'
endif

" mirscript
" Plug 'hilarryxu/vim-mirscript'

" Web
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'docunext/closetag.vim', { 'for': ['html', 'javascript'] }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'posva/vim-vue', { 'for': 'vue' }
" Plug 'hilarryxu/vim-coffeescript', { 'for': 'coffee' }

" gdb
if 0 && s:env.nvim
  Plug 'cpiger/NeoDebug'
endif

" Colorscheme
" Plug 'cocopon/iceberg.vim'
" Plug 'junegunn/seoul256.vim'
