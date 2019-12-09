let s:env = g:vimrc_env

" Coc {{{1
if HasPlug('coc.nvim')
  let g:coc_global_extensions = [
        \ 'coc-lists',
        \ 'coc-json',
        \ 'coc-snippets',
        \ 'coc-python',
        \ 'coc-bookmark',
        \ 'coc-yank',
        \ 'coc-explorer',
        \ 'coc-git'
        \ ]

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  function! s:show_documentation() abort
    if &filetype ==# 'vim'
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  imap <C-j> <Plug>(coc-snippets-expand-jump)
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  nmap <Leader>rn <Plug>(coc-rename)

  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  nmap gs <Plug>(coc-git-chunkinfo)
  nmap gb <Plug>(coc-git-commit)
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  nnoremap <silent> <Leader>ch  :<C-u>CocList helptags<cr>
  nnoremap <silent> <Leader>cg  :<C-u>CocList gstatus<CR>
  nnoremap <silent> <Leader>cb  :<C-u>CocList buffers<cr>
  nnoremap <silent> <Leader>cy  :<C-u>CocList yank<cr>
  nnoremap <silent> <Leader>cu  :<C-u>CocList snippets<cr>
  nnoremap <silent> <Leader>cw  :execute 'CocList -A -I --normal --input='.expand('<cword>').' words -w'<CR>
  nnoremap <silent> <Leader>cl  :<C-u>CocList locationlist<CR>
  nnoremap <silent> <Leader>cq  :<C-u>CocList quickfix<CR>
  nnoremap <silent> <Leader>ca  :<C-u>CocList diagnostics<cr>
  nnoremap <silent> <Leader>ce  :<C-u>CocList extensions<cr>
  nnoremap <silent> <Leader>cc  :<C-u>CocList commands<cr>
  nnoremap <silent> <Leader>co  :<C-u>CocList outline<cr>
  nnoremap <silent> <Leader>cs  :<C-u>CocList symbols<cr>
  nnoremap <silent> <Leader>cr  :<C-u>CocList mru<cr>
  nnoremap <silent> <Leader>cf  :<C-u>CocList files<cr>
  nnoremap <silent> <Leader>cj  :<C-u>CocNext<CR>
  nnoremap <silent> <Leader>ck  :<C-u>CocPrev<CR>
  nnoremap <silent> <Leader>cz  :<C-u>CocListResume<CR>

  " coc-explorer
  nmap ge :<C-u>CocCommand explorer<CR>
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
  if HasPlug('coc.nvim')
    nnoremap <Leader>fg :<C-U><C-R>=printf('CocList --normal grep %s', expand('<cword>'))<CR>
  else
    nnoremap <Leader>fg :<C-U><C-R>=printf('Leaderf! rg -F -e %s', expand('<cword>'))<CR>
  endif
  nnoremap <Leader>ft :<C-u>LeaderfBufTag<CR>
endif

" vim-calp {{{1
if HasPlug('vim-clap')
  nnoremap <Leader>fF :<C-u>Clap gfiles<CR>
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
if HasPlug('incsearch.vim')
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
endif

" vim-easy-align {{{1
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-smooth-scroll {{{1
" noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
" noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
" noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
" noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

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
