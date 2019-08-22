let s:env = g:vimrc_env

if s:env.has_python
  " LeaderF {{{1
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_DefaultExternalTool = 'rg'

  let g:Lf_ShortcutF = '<C-p>'
  let g:Lf_ShortcutB = '<Leader>fb'
  nnoremap <Leader>ff :<C-u>LeaderfFile<CR>
  nnoremap <Leader>fr :<C-u>LeaderfMru<CR>
  nnoremap <Leader>fl :<C-u>LeaderfLine<CR>
  nnoremap <Leader>fL :<C-u>LeaderfLineAll<CR>
  nnoremap <Leader>fg :<C-U><C-R>=printf('Leaderf! rg -F -e %s', expand('<cword>'))<CR>
else
  " CtrlP {{{1
  let g:ctrlp_map = ''
endif

" Airline {{{1
" let g:airline_powerline_fonts = 1
" let g:airline_theme = 'iceberg'
" 
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_idx_mode = 1
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

" nmap <Space>1 <Plug>AirlineSelectTab1
" nmap <Space>2 <Plug>AirlineSelectTab2
" nmap <Space>3 <Plug>AirlineSelectTab3
" nmap <Space>4 <Plug>AirlineSelectTab4
" nmap <Space>5 <Plug>AirlineSelectTab5
" nmap <Space>6 <Plug>AirlineSelectTab6
" nmap <Space>7 <Plug>AirlineSelectTab7
" nmap <Space>8 <Plug>AirlineSelectTab8
" nmap <Space>9 <Plug>AirlineSelectTab9

" Neomake {{{1
call neomake#configure#automake('rw', 1000)
let g:neomake_python_enabled_makers = ['flake8']
" let g:neomake_open_list = 2

" Ultisnips {{{1
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsEditSplit = 'vertical'

" Dirvish {{{1
nmap <Leader>dd <plug>(dirvish_up)

" vim-lookup {{{1
augroup vimrc_plugins
  autocmd FileType vim nnoremap <buffer><silent> <CR> :call lookup#lookup()<CR>
augroup END

" vim-expand-region {{{1
" map K <Plug>(expand_region_expand)
" map J <Plug>(expand_region_shrink)

" incsearch.vim {{{1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" vim-easy-align {{{1
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-smooth-scroll {{{1
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" vim-python-syntax {{{1
let g:python_highlight_builtins = 1
let g:python_highlight_builtin_objs = 1
let g:python_highlight_builtin_types = 1
let g:python_highlight_builtin_funcs = 1

" echodoc {{{1
set noshowmode
let g:echodoc#enable_at_startup = 1
