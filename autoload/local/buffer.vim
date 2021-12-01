function! local#buffer#safe_close() abort
  if winnr('$') > 1
    close
  else
    bd
  endif
endfunction

function! local#buffer#delete_others() abort
  let bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > bl[0] ? 'confirm '. bl[0] . ',.-bd' : '') (bufnr('') < bl[-1] ? '|confirm .+,$bd' : '')
endfunction
