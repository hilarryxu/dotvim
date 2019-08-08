function! s:sub(str, pat, rep) abort
  return substitute(a:str, '\v\C' . a:pat, a:rep, '')
endfunction

function! xcc#plug#edit#EV#commander(...) abort
  if a:0 == 0 || len(a:1) == 0
    edit $MYVIMRC
    return 1
  endif

  let arg = a:1

  " edit current ftplugin
  if arg ==# '.'
    let ftype = &filetype
    let path = $VIMHOME . '/ftplugin/' . ftype . '.vim'
    execute 'edit ' . path
    return 1
  endif

  " snip
  if arg ==# ',' && exists(':UltiSnipsEdit')
    UltiSnipsEdit
    return 1
  endif

  " edit file in cur file dir
  if arg[0] ==# ':'
    let path = expand('%:p:h') . '/' . arg[1:]
    execute 'edit ' . path
    return 1
  endif

  " full path
  if filereadable(arg)
    execute 'edit ' . path
    return 1
  endif

  echo 'cannot find vim file: ' . arg
  return 0
endfunction

function! xcc#plug#edit#EV#complete(ArgLead, CmdLine, CursorPos) abort
  if empty(a:ArgLead)
    return ['.', ',', ':']
  endif

  let base_dir = expand('%:p:h')
  let kw = a:ArgLead[1:] . '*'
  let items = split(globpath(base_dir, kw), "\n")
  return map(items, "':' . v:val[len(base_dir)+1:]")
endfunction
