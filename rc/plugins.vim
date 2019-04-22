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
else
  " CtrlP {{{1
  let g:ctrlp_map = ''
endif

if s:env.is_win
  " neosnippet {{{1
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)
endif

" Airline {{{1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'iceberg'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

nmap <Space>1 <Plug>AirlineSelectTab1
nmap <Space>2 <Plug>AirlineSelectTab2
nmap <Space>3 <Plug>AirlineSelectTab3
nmap <Space>4 <Plug>AirlineSelectTab4
nmap <Space>5 <Plug>AirlineSelectTab5
nmap <Space>6 <Plug>AirlineSelectTab6
nmap <Space>7 <Plug>AirlineSelectTab7
nmap <Space>8 <Plug>AirlineSelectTab8
nmap <Space>9 <Plug>AirlineSelectTab9

" Neomake {{{1
call neomake#configure#automake('rw', 1000)

" Ultisnips {{{1
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsEditSplit = 'vertical'

" BufferHint {{{1
nnoremap - :call bufferhint#Popup()<CR>
nnoremap <Leader>pp :call bufferhint#LoadPrevious()<CR>

let g:bufferhint_CustomHighlight = 1
hi! default link KeyHint Statement
hi! default link AtHint Identifier

" Dirvish {{{1
nmap <Leader>dd <plug>(dirvish_up)
