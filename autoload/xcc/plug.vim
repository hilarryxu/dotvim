if exists('s:loaded')
  finish
endif
let s:loaded = 1

let s:path = expand('<sfile>:p:h')

function! xcc#plug#load(...) abort "{{{
  if a:0 == 0 || empty(a:1)
    return
  endif

  for name in a:000
    if type(name) != type('')
      continue
    endif

    if name =~# '[/\]$'
      let name = substitute(name, '[/\]$', '')
    endif

    try
      call xcc#plug#{name}#plugin#load()
    catch
      echoerr '[plug] Fail to load plug: ' . name
      continue
    endtry
  endfor
endfunction "}}}

function! xcc#plug#complete(ArgLead, CmdLine, CursorPos) abort "{{{
  let items = glob(s:path . '/plug/' . a:ArgLead . '*/', 0, 1)
  let items = map(items, 'fnamemodify(v:val, ":p:h:t")')
  return items
endfunction "}}}

command! -nargs=* -complete=customlist,xcc#plug#complete PI call xcc#plug#load(<f-args>)
