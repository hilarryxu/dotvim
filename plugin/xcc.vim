if exists('g:loaded_xcc') || &cp
  finish
endif

" highlight groups {{{1
hi default xccTransparent gui=none guifg=background term=none cterm=none ctermfg=darkgray
hi default xccCommentLable term=standout ctermfg=darkyellow ctermbg=Red gui=none guifg=lightgray guibg=red
hi default xccConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
hi default xccTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

" commands {{{1
command! XccPlugins call xcc#plugin#dump()

" autocmd {{{1
augroup xcc_record
  au!
  au VimEnter,WinLeave * call xcc#window#record()
augroup END

" register plugins {{{1
call xcc#plugin#register('help', {'buftype': 'help'})
call xcc#plugin#register('qf', {'buftype': 'quickfix'})
