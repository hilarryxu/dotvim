" Location: autoload/xcc.vim

if exists('g:autoloaded_xcc') || &cp
  finish
endif
let g:autoloaded_xcc = 1

" Section: Utility

function! xcc#function(name) abort
  return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_'), ''))
endfunction

function! xcc#sub(str, pat, rep) abort
  return substitute(a:str, '\v\C'.a:pat, a:rep, '')
endfunction

function! xcc#gsub(str, pat, rep) abort
  return substitute(a:str, '\v\C'.a:pat, a:rep, 'g')
endfunction

function! xcc#shellesc(arg) abort
  if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  elseif &shell =~# 'cmd' && a:arg !~# '"'
    return '"'.a:arg.'"'
  else
    return shellescape(a:arg)
  endif
endfunction

function! xcc#fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file, " \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

function! xcc#shellslash(path) abort
  if exists('+shellslash') && !&shellslash
    return xcc#gsub(a:path, '\\', '/')
  else
    return a:path
  endif
endfunction

function! xcc#slash() abort
  return !exists("+shellslash") || &shellslash ? '/' : '\'
endfunction

function! xcc#capture(excmd) abort
  if exists('*execute')
    return execute(a:excmd)
  else
    try
      redir => cout
      execute 'silent! ' . a:excmd
    finally
      redir END
    endtry
    return cout
  endif
endfunction

function! xcc#scriptnames_qflist() abort
  let names = xcc#capture('scriptnames')
  let list = []
  for line in split(names, "\n")
    if line =~# ':'
      call add(list, {'text': matchstr(line, '\d\+'), 'filename': expand(matchstr(line, ': \zs.*'))})
    endif
  endfor
  return list
endfunction

function! xcc#scriptid(filename) abort
  let filename = fnamemodify(expand(a:filename), ':p')
  for script in xcc#scriptnames_qflist()
    if script.filename ==# filename
      return +script.text
    endif
  endfor
  return ''
endfunction
