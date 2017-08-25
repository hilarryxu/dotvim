" Find all occurrences of a pattern in a file.
function! xcc#find#buffer(pattern)
  if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
    call xcc#msg#warn("Cannot search the quickfix window")
    return
  endif
  try
    silent noautocmd execute "lvimgrep /" . a:pattern . "/gj " . fnameescape(expand("%"))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call xcc#msg#warn("No match")
  endtry
  bo lwindow
endfunction

" Find all occurrences of a pattern in all open files.
function! xcc#find#all_buffers(pattern)
  " Get the list of open files
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnameescape(bufname(v:val))')
  try
    silent noautocmd execute "vimgrep /" . a:pattern . "/gj " . join(l:files)
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call xcc#msg#warn("No match")
  endtry
  bo cwindow
endfunction

function! xcc#find#choose_dir(...) " ... is an optional prompt
  let l:idx = inputlist([get(a:000, 0, "Change directory to:"), "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
  let l:dir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
  if strlen(l:dir) <= 0
    call xcc#msg#notice("Cancelled.")
    return ''
  endif
  return l:dir
endfunction

function! xcc#find#grep(args)
  if getcwd() != expand("%:p:h")
    let l:dir = xcc#find#choose_dir()
    if empty(l:dir) | return | endif
    execute 'lcd' l:dir
  endif
  execute 'silent grep!' a:args
  bo cwindow
  redraw!
endfunction

function! xcc#find#grep_code(args)
  execute 'silent grep!' a:args
  bo cwindow
  redraw!
endfunction

" Filter a list and return a List of selected items.
" 'input' is any shell command that sends its output, one item per line, to
" stdout, or a List of items to be filtered.
function! xcc#find#fuzzy(input, ...)  " ... optional prompt
  if type(a:input) == v:t_string
    let l:cmd = a:input
  else " Assume List
      let l:input = tempname()
      call writefile(a:input, l:input)
      let l:cmd  = 'cat '.fnameescape(l:input)
  endif
  PP l:cmd
  let l:prompt = (a:0 > 0 ? "--prompt '".a:1. "> '" : '')
  let l:output = tempname()
  if executable('tput') && filereadable('/dev/tty')
    " Cool idea adapted from fzf.vim coming with fzf (not the Vim plugin):
    call system(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; '.l:cmd.'|fzf -m --height 20 '.l:prompt.' >'.fnameescape(l:output).' 2>/dev/tty', &lines))
  else
    silent execute '!'.l:cmd.'|fzf -m >'.fnameescape(l:output)
  endif
  redraw!
  try
    return filereadable(l:output) ? readfile(l:output) : []
  finally
    if exists("l:input")
      silent! call delete(l:input)
    endif
    silent! call delete(l:output)
  endtry
endfunction

" Filter a list of paths and populate the arglist with the selected items.
function! xcc#find#arglist(input_cmd)
  let l:arglist = xcc#find#fuzzy(a:input_cmd, 'Choose files')
  if empty(l:arglist) | return | endif
  execute "args" join(map(l:arglist, { i,v -> fnameescape(v) }))
endfunction

function! xcc#find#file(...) " ... is an optional directory
  if has('gui_running') || (!executable('ag') && !executable('rg'))
    execute 'CtrlP' (a:0 > 0 ? a:1 : '')
  elseif executable('ag')
    call xcc#find#arglist('ag -g ""' . (a:0 > 0 ? ' '.a:1 : ''))
  elseif executable('rg')
    call xcc#find#arglist('rg --files')
  endif
endfunction

function! xcc#find#colorscheme()
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colorscheme = xcc#find#fuzzy(l:colors, 'Theme')
  if !empty(l:colorscheme)
    execute "colorscheme" l:colorscheme[0]
  endif
endfunction
