" Command:
command! -range=0 -complete=shellcmd -nargs=+ Clam call xcc#plug#clam#func#ExeclamNormal(<count>, <line1>, <line2>, <q-args>)
command! -range=% -complete=shellcmd -nargs=+ ClamVisual call xcc#plug#clam#func#ExeclamVisual(<q-args>)

function! xcc#plug#clam#plugin#load() abort
  return 1
endfunction
