function! QMAdd(...) abort
  return call('xcc#plug#quickmenu#func#add', a:000)
endfunction

function! QMOpen(...) abort
  return call('xcc#plug#quickmenu#func#open', a:000)
endfunction

command! QMOpen :call xcc#plug#quickmenu#func#open()

noremap <silent><F12> :call xcc#plug#quickmenu#func#open()<CR>

function! xcc#plug#quickmenu#plugin#load() abort
  return 1
endfunction
