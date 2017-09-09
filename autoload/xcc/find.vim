" xcc#find#buffer {{{1
" Find all occurrences of a pattern in a file.
function! xcc#find#buffer(pattern) abort
  if getbufvar(winbufnr(winnr()), '&ft') ==# 'qf'
    call xcc#msg#warn("Cannot search the quickfix window")
    return
  endif

  try
    silent noautocmd execute 'lvimgrep /' . a:pattern . '/gj ' . fnameescape(expand('%'))
  catch /^Vim\%((\a\+)\)\=:E480/
    call xcc#msg#warn("No match")
  endtry

  botright lwindow
endfunction

" xcc#find#all_buffers {{{1
" Find all occurrences of a pattern in all open files.
function! xcc#find#all_buffers(pattern) abort
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnameescape(bufname(v:val))')

  try
    silent noautocmd execute 'vimgrep /' . a:pattern . '/gj ' . join(l:files)
  catch /^Vim\%((\a\+)\)\=:E480/
    call xcc#msg#warn("No match")
  endtry

  botright cwindow
endfunction

" xcc#find#choose_dir {{{1
" ... is an optional prompt
function! xcc#find#choose_dir(...) abort
  let l:idx = inputlist([get(a:000, 0, "Change directory to:"), "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
  let l:dir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
  if strlen(l:dir) <= 0
    call xcc#msg#notice("Cancelled")
    return ''
  endif
  return l:dir
endfunction

" xcc#find#grep {{{1
function! xcc#find#grep(args) abort
  if getcwd() != expand('%:p:h')
    let l:dir = xcc#find#choose_dir()
    if empty(l:dir) | return | endif
    execute 'lcd' l:dir
  endif
  execute 'silent grep!' a:args
  botright cwindow
  redraw!
endfunction

" xcc#find#fuzzy {{{1
" Filter a list and return a List of selected items.
" 'input' is any shell command that sends its output, one item per line, to
" stdout, or a List of items to be filtered.
" ... optional prompt
function! xcc#find#fuzzy(input, ...) abort
  if type(a:input) == v:t_string
    let l:cmd = a:input
    echom l:cmd
  else
    let l:input = tempname()
    call writefile(a:input, l:input)
    let l:cmd  = 'cat '.fnameescape(l:input)
  endif

  let l:prompt = (a:0 > 0 ? "-p '" . a:1 . "> '" : '')
  let l:output = tempname()
  if executable('tput') && filereadable('/dev/tty')
    " Cool idea adapted from fzf.vim coming with fzf (not the Vim plugin):
    call system(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; '
          \ . l:cmd . '|fzy -l 20 ' . l:prompt
          \ . ' >' . fnameescape(l:output)
          \ . ' 2>/dev/tty',
          \ &lines))
  else
    silent execute '!' . l:cmd . '|fzy>' . fnameescape(l:output)
  endif
  redraw!

  try
    return filereadable(l:output) ? readfile(l:output) : []
  finally
    if exists('l:input')
      silent! call delete(l:input)
    endif
    silent! call delete(l:output)
  endtry
endfunction

" xcc#find#arglist {{{1
" Filter a list of paths and populate the arglist with the selected items.
function! xcc#find#arglist(input_cmd) abort
  let l:arglist = xcc#find#fuzzy(a:input_cmd, 'Choose files')
  if empty(l:arglist) | return | endif
  execute 'args' join(map(l:arglist, { i,v -> fnameescape(v) }))
endfunction

" xcc#find#file {{{1
" Fuzzy find files.
" ... is an optional directory
function! xcc#find#file(...) abort
  if has('gui_running') || (!executable('rg') && !executable('rg'))
    execute 'CtrlP' (a:0 > 0 ? a:1 : '')
  elseif executable('rg')
    call xcc#find#arglist('rg' . (a:0 > 0 ? ' ' . a:1 : '') . ' --files --maxdepth=10 --color=never')
  elseif executable('ag')
    call xcc#find#arglist('ag -g ""' . (a:0 > 0 ? ' ' . a:1 : ''))
  endif
endfunction

" xcc#find#colorscheme {{{1
function! xcc#find#colorscheme() abort
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colorscheme = xcc#find#fuzzy(l:colors, 'Theme')
  if !empty(l:colorscheme)
    execute 'colorscheme' l:colorscheme[0]
  endif
endfunction
