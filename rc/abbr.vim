iabbrev Licence License
iabbrev cosnt const

function! SetupCommandAbbrs(from, to) abort
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

call SetupCommandAbbrs('Gs', 'Gstatus')
" call SetupCommandAbbrs('U', 'UltiSnipsEdit')
call SetupCommandAbbrs('T', 'tabe')
call SetupCommandAbbrs('F', 'Neoformat')
