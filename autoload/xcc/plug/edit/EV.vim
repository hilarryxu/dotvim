function! xcc#plug#edit#EV#commander(...) abort
  if a:0 == 0 || len(a:1) == 0
    edit $MYVIMRC
    return 1
  endif

  let arg = a:1

  if arg ==# ',' && exists(':UltiSnipsEdit')
    UltiSnipsEdit
    return 1
  endif

  echo 'Cannot find vim file: ' . arg
  return 0
endfunction
