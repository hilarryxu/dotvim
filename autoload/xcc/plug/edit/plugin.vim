command! -nargs=? EV call xcc#plug#edit#EV#commander(<f-args>)

function! xcc#plug#edit#plugin#load() abort
  return 1
endfunction
