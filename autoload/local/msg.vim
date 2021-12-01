function! s:msg(mode, message) abort
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endfunction

function! local#msg#notice(m) abort
  call s:msg('ModeMsg', a:m)
endfunction

function! local#msg#warn(m) abort
  call s:msg('WarningMsg', a:m)
endfunction

fun! local#msg#error(m) abort
  call s:msg('Error', a:m)
endfunction
