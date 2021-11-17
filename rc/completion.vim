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

  if HasPlug('coc.nvim')
    " pass
  endif

  if HasPlug('completor.vim')
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
  endif
elseif s:env.is_win
  " pass
endif
