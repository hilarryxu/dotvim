" helpers {{{1
function! s:sort_mappings(i1, i2)
  if a:i1.priority != a:i2.priority
    return a:i1.priority > a:i2.priority ? 1 : -1
  endif

  if a:i1.key !=# a:i2.key
    return a:i1.key ># a:i2.key ? 1 : -1
  endif

  return 0
endfunction

" xcc#keymap#register {{{1
" keymap: the dictionary used for store keymappings
" priority: a number to rule the help text order
" key: the key in Vim's key format string
" action: the action function name
" desc: description
function xcc#keymap#register(keymap, priority, local, key, action, desc)
  " pre-check
  if type(a:keymap) != type({})
    call xcc#msg#err("Wrong a:keymap type, please send a Dictionary")
    return
  endif

  " get key-mappings
  let a:keymap[a:key] = {
        \ 'priority': a:priority,
        \ 'local': a:local,
        \ 'key': a:key,
        \ 'action': a:action,
        \ 'desc': a:desc,
        \ }

  " immediately map non-local mappings
  if a:local == 0
    silent execute 'nnoremap <unique> '
          \ . a:key . ' '
          \ . a:action
  endif
endfunction

" xcc#keymap#bind {{{1
function xcc#keymap#bind(keymap)
  " pre-check
  if type(a:keymap) != type({}) 
    call xcc#msg#err("Wrong a:keymap type, please send a Dictionary")
    return
  endif

  let mappings = values(a:keymap)
  call sort(mappings, function('s:sort_mappings'))

  for m in mappings
    if m.local 
      silent execute 'nnoremap <silent> <buffer> '
            \ . m.key . ' '
            \ . m.action
    endif
  endfor
endfunction

" xcc#keymap#helptext {{{1
" return a list of help texts
function xcc#keymap#helptext(keymap)
  " pre-check
  if type(a:keymap) != type({})
    call xcc#msg#err("Wrong a:keymap type, please send a Dictionary")
    return []
  endif

  let mappings = values(a:keymap)
  call sort(mappings, function('s:sort_mappings'))

  let texts = []
  for m in mappings
    silent call add(texts, '" ' . m.key . ': ' . m.desc)
  endfor
  silent call add(texts, '')

  return texts
endfunction
