function! s:snip(text) abort
    call append(line('.') - 1, a:text)
endfunction

function! s:comment() abort
  let l:ext = expand('%:e')
  if &filetype ==? 'vim'
    return '"'
  elseif index(['c', 'cpp', 'h', 'hpp', 'hh', 'cc', 'cxx'], l:ext) >= 0
    return '//'
  elseif index(['m', 'mm', 'java', 'go', 'delphi', 'pascal'], l:ext) >= 0
    return '//'
  elseif index(['coffee', 'as'], l:ext) >= 0
    return '//'
  elseif index(['c', 'cpp', 'rust', 'go', 'javascript'], &filetype) >= 0
    return '//'
  elseif index(['coffee'], &filetype) >= 0
    return '//'
  elseif index(['sh', 'bash', 'python', 'php', 'perl', 'zsh'], &filetype) >= 0
    return '#'
  elseif index(['make', 'ruby', 'text'], &filetype) >= 0
    return '#'
  elseif index(['py', 'sh', 'pl', 'php', 'rb'], l:ext) >= 0
    return '#'
  elseif index(['asm', 's'], l:ext) >= 0
    return ';'
  elseif index(['asm'], &filetype) >= 0
    return ';'
  elseif index(['sql', 'lua'], l:ext) >= 0
    return '--'
  elseif index(['basic'], &filetype) >= 0
    return "'"
  endif
  return '#'
endfunction

function! s:comment_bar(repeat, limit) abort
  let comment = s:comment()
  while strlen(comment) < a:limit
    let comment .= a:repeat
  endwhile
  return comment
endfunc

function! xcc#plug#snip#func#comment_block(repeat) abort
  let comment = s:comment()
  let complete = s:comment_bar(a:repeat, 71)
  if comment ==# ''
    return
  endif
  call s:snip('')
  call s:snip(complete)
  call s:snip(comment . ' ')
  call s:snip(complete)
endfunction

function! xcc#plug#snip#func#modeline(repeat) abort
  let text = '" vim: set '
  let text .= (&l:et)? 'et ' : 'noet '
  let text .= 'fenc='. (&l:fenc) . ' '
  let text .= 'ff='. (&l:ff) . ' '
  let text .= 'sts='. (&l:sts). ' '
  let text .= 'sw='. (&l:sw). ' '
  let text .= 'ts='. (&l:ts). ' '
  let text .= ':'
  call append(line('.') - 1, text)
endfunction
