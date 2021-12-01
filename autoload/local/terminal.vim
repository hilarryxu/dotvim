if has('terminal')

  function! local#terminal#run(cmd, ...) abort
    let bufnr = term_start(a:cmd, extend({
          \ 'cwd': expand('%:p:h'),
          \ 'term_rows': 20,
          \ }, get(a:000, 0, {})))
    return bufnr
  endfunction

  function! local#terminal#open() abort
    let term_id = term_start(&shell, {'term_name': 'Terminal'})
    wincmd p
    let b:local_bound_terminal = term_id
  endfunction

  function! local#terminal#send_lines(lines) abort
    if empty(get(b:, 'local_bound_terminal', '')) || !bufexists(b:local_bound_terminal)
      let b:local_bound_terminal = str2nr(input('Terminal buffer: '))
    endif

    for l:line in a:lines
      call term_sendkeys(b:local_bound_terminal, l:line .. "\r")
      call s:term_wait(b:local_bound_terminal)
    endfor

    call cursor(line('.') + len(a:lines), 1)
  endfunction

  if has('gui_running')
    function! s:term_wait(bn) abort
    endfunction
  else
    function! s:term_wait(bn) abort
      call term_wait(a:bn)
    endfunction
  endif

endif  " terminal
