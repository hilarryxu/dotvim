function! s:msg(mode, message)
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endfunction

function! xcc#msg#notice(m)
  call s:msg('ModeMsg', a:m)
endfunction

function! xcc#msg#warn(m)
  call s:msg('WarningMsg', a:m)
endfunction

function! xcc#msg#err(m)
  call s:msg('Error', a:m)
endfunction
