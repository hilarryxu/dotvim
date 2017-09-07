if exists('g:loaded_xcc') || &cp
  finish
endif

" highlight groups {{{1
hi default xccTransparent gui=none guifg=background term=none cterm=none ctermfg=darkgray
hi default xccCommentLable term=standout ctermfg=darkyellow ctermbg=Red gui=none guifg=lightgray guibg=red
hi default xccConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
hi default xccTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

" commands {{{1
command! XCCbn call xcc#buffer#navigate('bn')
command! XCCbp call xcc#buffer#navigate('bp')
command! XCCbalt call xcc#buffer#to_alternate_edit_buf()
command! XCCbd call xcc#buffer#keep_window_bd()

command! XCCsw call xcc#window#switch_window()
command! XCCgp call xcc#window#goto_plugin_window()

command! XCCplugins call xcc#plugin#dump()
command! XCCdumpBuffer call xcc#buffer#dump()
command! XCCdumpWindow call xcc#window#dump()

" autocmd {{{1
augroup xcc_record
  au!
  au VimEnter,WinLeave * call xcc#window#record()
  au BufLeave * call xcc#buffer#record()
augroup END

" register plugins {{{1
call xcc#plugin#register('help', {'buftype': 'help'})
call xcc#plugin#register('qf', {'buftype': 'quickfix'})
