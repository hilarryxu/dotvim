function! local#win#zoom_toggle() abort
  " only one window
  if winnr('$') == 1 | return | endif

  if exists('t:zoom_restore')
    execute t:zoom_restore
    unlet t:zoom_restore
  else
    let t:zoom_restore = winrestcmd()
    wincmd |
    wincmd _
  endif
endfunction
