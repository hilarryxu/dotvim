" helpers {{{1
function! s:msg(mode, message)
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endfunction

" xcc#msg#notice {{{1
function! xcc#msg#notice(m)
  call s:msg('ModeMsg', a:m)
endfunction

" xcc#msg#warn {{{1
function! xcc#msg#warn(m)
  call s:msg('WarningMsg', a:m)
endfunction

" xcc#msg#err {{{1
function! xcc#msg#err(m)
  call s:msg('Error', a:m)
endfunction

" xcc#msg#debug {{{1
function! xcc#msg#debug(m)
  let msg = 'Debug(xcc): ' . a:m . ', ' . expand('<sfile>')
  call s:msg('Special', msg)
endfunction
