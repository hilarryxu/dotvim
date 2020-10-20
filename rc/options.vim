let s:env = g:vimrc_env

let mapleader = ','
let maplocalleader = "\\"

" Basic
set hidden
set nonumber
set showcmd
set showmatch
set notitle
set nowrap
set list
set shortmess+=c
set belloff+=ctrlg

" Statusline
" set statusline=%t\ %m\ %r\ [%{&fileencoding},%{&ff}%Y]\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

" Window split
set splitright
set splitbelow

" Make and Grep
if executable('rg')
  set grepprg=rg\ -i\ --vimgrep
endif
set grepformat^=%f:%l:%c:%m

" Complete option
set completeopt+=menuone,noselect
set completeopt-=preview

" File format and encoding
set encoding=utf-8
set fileencodings=utf-8,gbk,chinese,cp936,gb18030,utf-16le,utf-16,big5,euc-jp,euc-kr,latin-1
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileformat=unix

" Backup
set nobackup
set noswapfile
execute 'set undodir=' . s:env.path.undo
set undofile

" Tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Ignore
set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
set wildmenu " Show possible matches when autocompleting
set wildignorecase " Ignore case when completing file names and directories

" Search
set hlsearch
set noignorecase
set incsearch
set smartcase
set wrapscan

" Fold
set foldlevel=99

" Disable sounds
set noerrorbells
set novisualbell
set t_vb=

" nvim
if s:env.nvim
  let g:loaded_python_provider = 1
  let g:python_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif

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
  if s:env.is_win
    set guifont=Consolas_for_Powerline_FixedD:h11:cANSI
  endif
endif
