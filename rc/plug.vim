let s:env = g:vimrc_env

" Enhancement
Plug 'thinca/vim-localrc'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-eunuch'
Plug 'itchyny/vim-cursorword'
" Plug 'mhinz/vim-signify'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'fisadev/FixedTaskList.vim'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/incsearch.vim'

" File finder
if s:env.has_python
  Plug 'Yggdroot/LeaderF'
else
  Plug 'ctrlpvim/ctrlp.vim'
endif

" Coding
Plug 'tpope/vim-commentary'
Plug 'neomake/neomake' | Plug 'tracyone/neomake-multiprocess'
Plug 'sbdchd/neoformat'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

" Git
if executable('git')
  Plug 'tpope/vim-fugitive' | Plug 'junegunn/gv.vim'
endif

" Completion
if s:env.has_python && !s:env.is_win
  Plug 'maralla/completor.vim'
elseif s:env.is_win
  Plug 'Shougo/neocomplete.vim'
endif

" Snippet
if s:env.has_python && !s:env.is_win
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
elseif s:env.is_win
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
endif

" Python
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

" Web
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'docunext/closetag.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'posva/vim-vue', { 'for': 'vue' }

" Colorscheme
Plug 'cocopon/iceberg.vim'
Plug 'junegunn/seoul256.vim'
