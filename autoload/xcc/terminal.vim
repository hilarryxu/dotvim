function! xcc#terminal#open() abort
  call system('tmux split-window')
  call system('tmux last-pane')
endfunction

function! xcc#terminal#send(lines) abort
  if !exists('b:xcc_bound_terminal') || empty(b:xcc_bound_terminal)
    let b:xcc_bound_terminal = input('Tmux pane number: ')
  endif
  for line in a:lines
    call system('tmux -u send-keys -l -t ' . b:xcc_bound_terminal . ' "" ' . shellescape(line . "\r"))
  endfor
endfunction

function! xcc#terminal#meta_mode(mode) abort
  if has('nvim') || has('gui_running')
    return
  endif

  function! s:metacode(mode, key)
    if a:mode == 0
      exec "set <M-".a:key.">=\e".a:key
    else
      exec "set <M-".a:key.">=\e]{0}".a:key."~"
    endif
  endfunc

  for i in range(10)
    call s:metacode(a:mode, nr2char(char2nr('0') + i))
  endfor
  for i in range(26)
    call s:metacode(a:mode, nr2char(char2nr('a') + i))
    call s:metacode(a:mode, nr2char(char2nr('A') + i))
  endfor

  if a:mode != 0
    for c in [',', '.', '/', ';', '[', ']', '{', '}']
      call s:metacode(a:mode, c)
    endfor
    for c in ['?', ':', '-', '_']
      call s:metacode(a:mode, c)
    endfor
  else
    for c in [',', '.', '/', ';', '{', '}']
      call s:metacode(a:mode, c)
    endfor
    for c in ['?', ':', '-', '_']
      call s:metacode(a:mode, c)
    endfor
  endif

  if &ttimeout == 0
    set ttimeout
  endif
  if &ttimeoutlen <= 0
    set ttimeoutlen=100
  endif
endfunction
