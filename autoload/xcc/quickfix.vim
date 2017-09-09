" funcs {{{1
function! s:window_check(mode) abort
  if &buftype == 'quickfix'
    let s:quickfix_open = 1
    return
  endif
  if a:mode == 0
    let w:xcc_quickfix_save = winsaveview()
  else
    if exists('w:xcc_quickfix_save')
      call winrestview(w:xcc_quickfix_save)
      unlet w:xcc_quickfix_save
    endif
  endif
endfunction

" xcc#quickfix#toggle {{{1
" size: quickfix window height
" mode: 0 close 1 open 2 toggle
function! xcc#quickfix#toggle(size, ...) abort
  let l:mode = (a:0 == 0)? 2 : (a:1)
  let s:quickfix_open = 0
  let l:winnr = winnr()
  noautocmd windo call s:window_check(0)
  noautocmd silent! execute '' . l:winnr . 'wincmd w'

  if l:mode == 0
    if s:quickfix_open != 0
      silent! cclose
    endif
  elseif l:mode == 1
    if s:quickfix_open == 0
      exec 'botright copen ' . ((a:size > 0) ? a:size : ' ')
      wincmd k
    endif
  elseif l:mode == 2
    if s:quickfix_open == 0
      exec 'botright copen ' . ((a:size > 0) ? a:size : ' ')
      wincmd k
    else
      silent! cclose
    endif
  endif

  noautocmd windo call s:window_check(1)
  noautocmd silent! exec '' . l:winnr . 'wincmd w'
endfunction
