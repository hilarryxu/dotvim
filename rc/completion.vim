let s:env = g:vimrc_env

if s:env.nvim
  " function! Tab_Or_Complete() abort
  "   if pumvisible()
  "     return "\<C-N>"
  "   elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^[[:keyword:][:ident:]]'
  "     return "\<C-R>=completor#do('complete')\<CR>"
  "   else
  "     return "\<Tab>"
  "   endif
  " endfunction

  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " let g:completor_auto_trigger = 0
  " inoremap <expr> <Tab> Tab_Or_Complete()
  "
  inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
elseif s:env.is_win
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1

  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#sources#omni#min_keyword_length = 3

  let g:neocomplete#max_list = 8
  let g:neocomplete#sources#buffer#max_keyword_width = 30

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  " let g:neocomplete#sources#omni#input_patterns.python = ''

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  " let g:neocomplete#force_omni_input_patterns.css = '^\s\+\k\+\|\w\+[):;]\?\s\+\k*\|[@!]'


  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"


  augroup completion_omni
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
endif
