function! local#text#tab_width(...) abort
  if a:0 > 0
    let twd = a:1 > 0 ? a:1 : 1
    let &l:tabstop=twd
    let &l:shiftwidth=twd
    let &l:softtabstop=twd
  endif

  echo &l:tabstop
endfunction

function! local#text#selection() abort
  if getpos("'>") != [0, 0, 0, 0]
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return lines
  else
    call local#msg#warn("No selection markers")
    return []
  end
endfunction

function! local#text#diff_orig() abort
  vert new
  setl buftype=nofile bufhidden=wipe nobuflisted noswapfile
  silent read ++edit #
  norm ggd_
  execute 'setfiletype' getbufvar('#', '&ft')
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  diffthis
endfunction
