" noremap <M-x> :echo "ALT-X pressed"<CR>
" noremap <A-p> :echo "ALT-P pressed"<CR>
" noremap <Esc>x :echo "ESC-X pressed"<CR>

" Let's vim
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
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

" Window move
" nnoremap <C-l> <C-w>l
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k

" Buffer
nnoremap H :bp<CR>
nnoremap L :bn<CR>
nnoremap <Leader>bq :bp <BAR> bd #<CR>

" Inser pairs
inoremap <C-x>( ()<Esc>i
inoremap <C-x>9 ()<Esc>i
inoremap <C-x>[ []<Esc>i
inoremap <C-x>' ''<Esc>i
inoremap <C-x>" ""<Esc>i
inoremap <C-x>< <><Esc>i
inoremap <C-x>{ {<Esc>o}<Esc>ko

" Leader stuff
nnoremap <silent> <Leader>ma :<C-u>update<CR>:silent make<BAR>redraw!<BAR>bo cwindow<CR>
nnoremap <silent> <Leader><Space> :nohlsearch<CR>

" Some usefull maps
nnoremap ; :
noremap j gj
noremap k gk
vnoremap < <gv
vnoremap > >gv
noremap <C-g> 2<C-g>
set pastetoggle=<F9>
nnoremap gQ <Nop>
nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>
nnoremap gf :edit <cfile><CR>
