function! s:goup(path, patterns) abort
  let l:path = a:path
  while 1
    for l:pattern in a:patterns
      let l:current = l:path . '/' . l:pattern
      if stridx(l:pattern, '*') != -1 && !empty(glob(l:current, 1))
        return l:path
      elseif l:pattern =~# '/$'
        if isdirectory(l:current)
          return l:path
        endif
      elseif filereadable(l:current)
        return l:path
      endif
    endfor
    let l:next = fnamemodify(l:path, ':h')
    if l:next == l:path || (has('win32') && l:next =~# '^//[^/]\+$')
      break
    endif
    let l:path = l:next
  endwhile
  return ''
endfunction

function! xcc#util#findroot#get() abort
  let l:bufname = expand('%:p')
  if &buftype !=# '' || stridx(l:bufname, '://') !=# -1
    return ''
  endif
  if !empty(l:bufname)
    let l:dir = escape(fnamemodify(l:bufname, ':p:h:gs!\!/!'), ' ')
  else
    let l:dir = escape(fnamemodify(getcwd(), ':gs!\!/!'), ' ')
  endif
  let l:patterns = get(g:, 'findroot_patterns', [
  \  '.git/',
  \  '.svn/',
  \  '.hg/',
  \  '.bzr/',
  \  '.gitignore',
  \  'Rakefile',
  \  'pom.xml',
  \  'project.clj',
  \  'package.json',
  \  'manifest.json',
  \  '*.csproj',
  \  '*.sln',
  \])
  return s:goup(l:dir, l:patterns)
endfunction
