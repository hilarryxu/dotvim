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

function! s:get_effectual_lines(qf) abort
  return filter(deepcopy(a:qf), 's:is_effectual_line(v:val)')
endfunction

function! s:is_effectual_line(qf_line) abort
  return get(a:qf_line, 'bufnr', 0)
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

" xcc#quickfix#filter {{{1
" option: 'pattern', 'file'
" reverse: 0, 1
function! xcc#quickfix#filter(pattern, option, reverse) abort
  if a:pattern == ''
    call xcc#msg#warn("Search pattern is empty")
    return
  endif

  let s:xcc_orig_qflist = getqflist()
  let l:text = ''
  let l:idx = -1
  let l:qflist = []
  for e in s:get_effectual_lines(s:xcc_orig_qflist)
    if a:option ==# 'pattern'
      let l:text = e.text
    elseif a:option ==# 'file'
      let l:text = bufname(e.bufnr)
    endif

    let l:idx = match(l:text, a:pattern)
    if a:reverse
      if l:idx < 0
        call add(l:qflist, copy(e))
      endif
    else
      if l:idx >= 0
        call add(l:qflist, copy(e))
      endif
    endif
  endfor

  call setqflist(l:qflist, 'r')

  call xcc#msg#notice('Filter ' . a:option . ': ' . a:pattern)
endfunction

" xcc#quickfix#restore {{{1
function! xcc#quickfix#restore() abort
  if &buftype != 'quickfix'
    call xcc#msg#warn('Not a quickfix window')
    return
  endif

  if !exists('s:xcc_orig_qflist')
    call xcc#msg#notice('Nothing to estore')
    return
  endif

  call setqflist(s:xcc_orig_qflist, 'r')
  call xcc#msg#notice('Restore orig qflist')
endfunction
