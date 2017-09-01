function! s:window_check(mode)
  if getbufvar('%', '&buftype') == 'quickfix'
    let s:quickfix_open = 1
    return
  endif
  if a:mode == 0
    let w:xcc_quickfix_save = winsaveview()
  else
    call winrestview(w:xcc_quickfix_save)
  endif
endfunction

function! xcc#quickfix#toggle(size)
  let s:quickfix_open = 0
  let l:winnr = winnr()
  windo call s:window_check(0)
  if s:quickfix_open == 0
    execute 'botright copen ' . a:size
    wincmd k
  else
    cclose
  endif
  windo call s:window_check(1)
  silent execute '' . l:winnr . 'wincmd w'
endfunction
