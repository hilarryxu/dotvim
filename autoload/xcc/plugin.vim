" Location:     autoload/xcc/plugin.vim

let s:registered_plugin = {}
let s:empty_filetype = '__EMPTY__'

function xcc#plugin#dump()
  silent echohl Statement
  echo 'List of registered plugins:'
  silent echohl None

  for [k, v] in items(s:registered_plugin)
    if empty(v)
      echo k . ': {}'
    else
      for e in v
        echo k . ': ' . string(e)
      endfor
    endif
  endfor
endfunction

function xcc#plugin#register(filetype, options)
  let filetype = a:filetype
  if filetype == ''
    let filetype = s:empty_filetype
  endif

  let rules = []
  if !has_key(s:registered_plugin, filetype)
    let s:registered_plugin[filetype] = rules
  else
    let rules = s:registered_plugin[filetype]
  endif

  if !empty(a:options)
    silent call add(rules, a:options)
  endif
endfunction

function xcc#plugin#is_registered(bufnr, ...)
  if !bufexists(a:bufnr)
    return 0
  endif

  let bufname = bufname(a:bufnr)
  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype == ''
    let filetype = s:empty_filetype
  endif

  if !has_key(s:registered_plugin, filetype)
    return 0
  endif

  let rules = s:registered_plugin[filetype]
  if empty(rules)
    return 1
  endif

  for rule_dict in rules
    let failed = 0

    for key in keys(rule_dict)
      " NOTE: this is because the value here can be list or string, if
      " we don't unlet it, it will lead to E706
      if exists('l:value')
        unlet value
      endif

      let value = rule_dict[key]

      " check bufname
      if key ==# 'bufname'
        if match(bufname, value) == -1
          let failed = 1
          break
        endif
        continue
      endif

      " skip autoclose
      if key ==# 'actions'
        if a:0 > 0
          silent call extend(a:1, value)
        endif
        continue
      endif

      " check other option
      let buf_option = getbufvar(a:bufnr, '&' . key)
      if buf_option !=# value
        let failed = 1
        break
      endif
    endfor

    if failed == 0
      return 1
    endif
  endfor

  return 0
endfunction
