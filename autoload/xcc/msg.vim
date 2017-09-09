" helpers {{{1
function! s:msg(mode, message) abort
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endfunction

" xcc#msg#notice {{{1
function! xcc#msg#notice(m) abort
  call s:msg('ModeMsg', a:m)
endfunction

" xcc#msg#warn {{{1
function! xcc#msg#warn(m) abort
  call s:msg('WarningMsg', a:m)
endfunction

" xcc#msg#err {{{1
function! xcc#msg#err(m) abort
  call s:msg('Error', a:m)
endfunction

" xcc#msg#debug {{{1
function! xcc#msg#debug(m) abort
  let msg = 'Debug(xcc): ' . a:m . ', ' . expand('<sfile>')
  call s:msg('Special', msg)
endfunction
