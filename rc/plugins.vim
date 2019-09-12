let s:env = g:vimrc_env

" Coc {{{1
" CocInstall coc-lists
" CocInstall coc-json
" CocInstall coc-python
" CocInstall coc-snippets
" CocInstall coc-bookmark
if HasPlug('coc.nvim')
endif

" LeaderF {{{1
if HasPlug('LeaderF')
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_DefaultExternalTool = 'rg'

  let g:Lf_ShortcutF = '<C-p>'
  let g:Lf_ShortcutB = '<Leader>fb'
  nnoremap <Leader>ff :<C-u>LeaderfFile<CR>
  nnoremap <Leader>fr :<C-u>LeaderfMru<CR>
  nnoremap <Leader>fl :<C-u>LeaderfLine<CR>
  nnoremap <Leader>fL :<C-u>LeaderfLineAll<CR>
  nnoremap <Leader>fg :<C-U><C-R>=printf('Leaderf! rg -F -e %s', expand('<cword>'))<CR>
endif

" Neomake {{{1
call neomake#configure#automake('rw', 1000)
let g:neomake_python_enabled_makers = ['flake8']
" let g:neomake_open_list = 2

" Ultisnips {{{1
if HasPlug('ultisnips')
  let g:UltiSnipsNoPythonWarning = 1
  let g:UltiSnipsExpandTrigger = '<C-j>'
  let g:UltiSnipsJumpForwardTrigger = '<C-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
  let g:UltiSnipsEditSplit = 'vertical'
endif

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

" preview.vim {{{1
noremap <silent><M-;> :PreviewTag<CR>
noremap <silent><M-:> :PreviewClose<CR>
noremap <silent><Tab>; :PreviewGoto edit<CR>
noremap <silent><Tab>: :PreviewGoto tabe<CR>

nnoremap <silent><M-a> :PreviewSignature<CR>
inoremap <silent><M-a> <C-\><C-o>:PreviewSignature<CR>

noremap <M-u> :PreviewScroll -1<CR>
noremap <M-d> :PreviewScroll +1<CR>
inoremap <M-u> <C-\><C-o>:PreviewScroll -1<CR>
inoremap <M-d> <C-\><C-o>:PreviewScroll +1<CR>

function! s:quickfix_keymap() abort
  if &buftype !=# 'quickfix'
    return
  endif
  nnoremap <silent><buffer> p :PreviewQuickfix<CR>
  nnoremap <silent><buffer> P :PreviewClose<CR>
  nnoremap <silent><buffer> q :close<CR>
  setlocal nonumber
endfunc

augroup vimrc_plugins
  autocmd FileType qf call s:quickfix_keymap()
augroup END
