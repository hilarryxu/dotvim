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
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

" Window move
" nnoremap <C-l> <C-w>l
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k

" Buffer
nnoremap <Leader>bq :bp <BAR> bd #<CR>
nnoremap <silent> <Leader>bc :<C-u>call V_buffer_close()<CR>
nnoremap <silent> <Leader>bo :<C-u>call V_buffer_only()<CR>
nnoremap <silent> <Leader>bm :<C-u>VimCmd messages<CR>
nnoremap <silent> <Leader>bs :<C-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<CR>

" Tab
nmap <Leader>1 1gt
nmap <Leader>2 2gt
nmap <Leader>3 3gt
nmap <Leader>4 4gt
nmap <Leader>5 5gt
nmap <Leader>6 6gt
nmap <Leader>7 7gt
nmap <Leader>8 8gt

" Inser pairs
inoremap <C-x>( ()<Esc>i
inoremap <C-x>9 ()<Esc>i
inoremap <C-x>[ []<Esc>i
inoremap <C-x>' ''<Esc>i
inoremap <C-x>" ""<Esc>i
inoremap <C-x>< <><Esc>i
inoremap <C-x>{ {<Esc>o}<Esc>ko

" Leader stuff
nnoremap <silent> <Leader>es :call V_strip_trailing_whitespaces()<CR>
nnoremap <silent> <Leader>ma :<C-u>update<CR>:silent make<BAR>redraw!<BAR>bo cwindow<CR>
nnoremap <silent> <Leader><Space> :nohlsearch<CR>

" Some usefull maps
" nnoremap ; :
noremap j gj
noremap k gk
vnoremap < <gv
vnoremap > >gv
noremap <C-g> 2<C-g>
set pastetoggle=<F9>
nnoremap gQ <Nop>
nnoremap <silent> cd :<C-u>cd %:h \| pwd<CR>
" nnoremap gf :edit <cfile><CR>
