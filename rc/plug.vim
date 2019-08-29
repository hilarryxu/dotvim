let s:env = g:vimrc_env

" Enhancement
Plug 'thinca/vim-localrc'
" Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
" Plug 'tpope/vim-eunuch'
" Plug 'itchyny/vim-cursorword'
" Plug 'mhinz/vim-signify'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-slash'
" Plug 'fisadev/FixedTaskList.vim'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/incsearch.vim'
Plug 'mtth/scratch.vim'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-smooth-scroll'
Plug 'rhysd/clever-f.vim'
Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for': ['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
Plug 'bps/vim-textobj-python', { 'for': 'python' }
Plug 'jceb/vim-textobj-uri'

" File finder
if s:env.has_python
  Plug 'Yggdroot/LeaderF'
else
  Plug 'ctrlpvim/ctrlp.vim'
endif

" Coding
Plug 'tpope/vim-commentary'
Plug 'skywind3000/asyncrun.vim'
Plug 'neomake/neomake' | Plug 'tracyone/neomake-multiprocess'
Plug 'sbdchd/neoformat'
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'Shougo/echodoc.vim'
Plug 'hilarryxu/vim-dict'
Plug 'skywind3000/vim-preview'

" Git
if executable('git')
  Plug 'tpope/vim-fugitive' | Plug 'junegunn/gv.vim'
endif

" Completion
if s:env.has_python
  Plug 'maralla/completor.vim'
  " Plug 'Shougo/neco-vim' | Plug 'maralla/completor-necovim'
endif

" Snippet
if s:env.has_python
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
else
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
endif

" Vim
Plug 'mhinz/vim-lookup', { 'for': 'vim' }

" Python
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'hilarryxu/vim-bundle-mako'

" Web
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'docunext/closetag.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'posva/vim-vue', { 'for': 'vue' }

" Colorscheme
Plug 'cocopon/iceberg.vim'
Plug 'junegunn/seoul256.vim'
