" Find other window with max area
function! s:find_another() abort
  let area = 0
  let max = 0
  let idx = 0
  let cur = winnr()
  for i in range(1, winnr('$'))
    if i == cur
      continue
    endif
    let area = winwidth(i) * winheight(i)
    if area > max
      let max = area
      let idx = i
    endif
  endfor
  return idx
endfunction

function! xcc#plug#edit#ED#edit_another(...) abort
  if winnr('$') == 1
    vsplit
  else
    let idx = s:find_another()
    execute 'buffer ' . winbufnr(idx)
  endif
endfunction

function! xcc#plug#edit#ED#edit_in_another(...) abort
  let cur_bufnr = winbufnr(0)
  if winnr('$') == 1
    vsplit
  else
    let idx = s:find_another()
    execute idx . 'wincmd w'
    execute 'buffer ' . cur_bufnr
  endif
endfunction

function! xcc#plug#edit#ED#tag_in_another(tagname) abort
  if winnr('$') == 1
    execute 'vertical stag ' . a:tagname
  else
    let idx = s:find_another()
    execute idx . 'wincmd w'
    execute 'tag ' . a:tagname
  endif
endfunction

function! xcc#plug#edit#ED#pop_in_another() abort
  if winnr('$') == 1
    vsplit
    pop
  else
    let idx = s:find_another()
    execute idx . 'wincmd w'
    pop
  endif
endfunction

function! xcc#plug#edit#ED#copy_to_another(mode) abort
  if winnr('$') == 1
    echoerr 'Need split another windows'
    return
  endif

  if a:mode ==? 'v'
    normal! gvy
  else
    normal! yy
  endif

  let idx = s:find_another()
  execute idx . 'wincmd w'
  normal! p
  wincmd p
endfunction

function! xcc#plug#edit#ED#move_to_another(mode) abort
  if winnr('$') == 1
    echoerr 'Need split another windows'
    return
  endif

  if a:mode ==? 'v'
    normal! gvd
  else
    normal! dd
  endif

  let idx = s:find_another()
  execute idx . 'wincmd w'
  normal! p
  wincmd p
endfunction
