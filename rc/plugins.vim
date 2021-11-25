let s:env = g:vimrc_env

" Coc {{{1
if HasPlug('coc.nvim')
  " coc-pyright
  let g:coc_global_extensions = [
        \ 'coc-lists',
        \ 'coc-json',
        \ 'coc-snippets',
        \ 'coc-yank',
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
  nnoremap <silent> <Leader>cm  :<C-u>CocList marks<cr>
  nnoremap <silent> <Leader>cj  :<C-u>CocNext<CR>
  nnoremap <silent> <Leader>ck  :<C-u>CocPrev<CR>
  nnoremap <silent> <Leader>cz  :<C-u>CocListResume<CR>
endif

" LeaderF {{{1
if HasPlug('LeaderF')
  let g:Lf_HideHelp = 1
  let g:Lf_UseCache = 0
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_DefaultExternalTool = 'rg'
  let g:Lf_IgnoreCurrentBufferName = 1

  let g:Lf_WindowPosition = 'popup'
  let g:Lf_PreviewInPopup = 1

  let g:Lf_ShortcutF = '<C-p>'
  let g:Lf_ShortcutB = '<Leader>fb'
  noremap <m-p> :LeaderfFunction!<cr>
  noremap <m-n> :LeaderfBuffer<cr>
  noremap <m-m> :LeaderfTag<cr>
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

  noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
  noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
  xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
  noremap go :<C-U>Leaderf! rg --recall<CR>

  " should use `Leaderf gtags --update` first
  let g:Lf_GtagsAutoGenerate = 0
  let g:Lf_Gtagslabel = 'native-pygments'
  noremap <Leader>gr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap <Leader>gd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap <Leader>go :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
  noremap <Leader>gn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
  noremap <Leader>gp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
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
if HasPlug('vim-dirvish')
  nmap <Leader>dd <plug>(dirvish_up)
endif

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
if HasPlug('vim-easy-align')
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
endif

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

" echodoc.vim {{{1
if HasPlug('echodoc.vim')
  set noshowmode
  let g:echodoc#enable_at_startup = 1
endif

" vim-preview {{{1
if HasPlug('vim-preview')
  noremap <silent><M-;> :PreviewTag<CR>
  noremap <silent><M-:> :PreviewClose<CR>
  noremap <silent><Tab>; :PreviewGoto edit<CR>
  noremap <silent><Tab>: :PreviewGoto tabe<CR>

  " nnoremap <silent><M-a> :PreviewSignature<CR>
  " inoremap <silent><M-a> <C-\><C-o>:PreviewSignature<CR>
  nnoremap <silent><M-.> :PreviewSignature<CR>
  inoremap <silent><M-.> <C-\><C-o>:PreviewSignature<CR>

  noremap <M-u> :PreviewScroll -1<CR>
  noremap <M-d> :PreviewScroll +1<CR>
  inoremap <M-u> <C-\><C-o>:PreviewScroll -1<CR>
  inoremap <M-d> <C-\><C-o>:PreviewScroll +1<CR>
endif

" xcc#fzy {{{1
if !HasPlug('LeaderF')
  nnoremap <silent> <C-p> :call xcc#fzy#files()<CR>
endif

" vim-sneak {{{1
if HasPlug('vim-sneak')
  nmap <c-s> <plug>Sneak_s
  nmap gs <plug>Sneak_S
  let g:sneak#label = 1
  " let g:sneak#use_ic_scs = 1
endif

" vim-operator-surround {{{1
if HasPlug('vim-operator-surround')
  map <silent>sa <Plug>(operator-surround-append)
  map <silent>sd <Plug>(operator-surround-delete)
  map <silent>sr <Plug>(operator-surround-replace)

  nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
  nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
endif

" vim-gutentags {{{1
if HasPlug('vim-gutentags')
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
  let g:gutentags_ctags_tagfile = '.tags'
  let s:vim_tags = expand('~/.cache/tags')
  let g:gutentags_cache_dir = s:vim_tags
  if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
  endif
endif

let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" others {{{1
if HasPlug('coc.nvim')
  noremap - :<C-u>CocList buffers<CR>
endif

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
