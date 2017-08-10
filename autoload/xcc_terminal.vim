function! xcc_terminal#meta_mode(mode)
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

function! xcc_terminal#alt_map_tab()
  if has('gui_running')
    return
  endif
  for i in range(10)
    let x = (i == 0)? 10 : i
    exec "noremap <silent><M-".i."> :tabn ".x."<cr>"
    exec "inoremap <silent><M-".i."> <ESC>:tabn ".x."<cr>"
  endfor
  noremap <silent><m-o> :tabnew<cr>
  inoremap <silent><m-o> <ESC>:tabnew<cr>
  noremap <silent><m-t> :tabnew<cr>
  inoremap <silent><m-t> <ESC>:tabnew<cr>
  " noremap <silent><m-w> :tabclose<cr>
  " inoremap <silent><m-w> <ESC>:tabclose<cr>
  noremap <silent><m-e> :tabclose<cr>
  inoremap <silent><m-e> <ESC>:tabclose<cr>
  noremap <m-s> :w<cr>
  inoremap <m-s> <esc>:w<cr>
endfunction
