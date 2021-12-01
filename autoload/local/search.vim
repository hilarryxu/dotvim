function! local#search#cur_buffer(pattern) abort
  if getbufvar(winbufnr(winnr()), '&ft') ==# 'qf'
    call local#msg#warn("Cannot search the quickfix window")
    return
  endif

  try
    silent noautocmd execute 'lvimgrep /' . a:pattern . '/gj ' . fnameescape(expand('%'))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call local#msg#warn("No match")
  endtry

  bo lwindow
endfunction

function! local#search#grep(args) abort
  let chars = (&grepprg =~# 'internal' ? '#' : '#%')
  let rg = (&grepprg =~# '^\f*rg\s')

  execute 'silent grep!' shellescape(escape(a:args, chars)) (rg ? '': '**/*')
  botright cwindow
  redraw!
endfunction

let s:env = VimrcEnvironment()

function! s:get_ff_output(inpath, outpath, callback, channel, status) abort
  let output = filereadable(a:outpath) ? readfile(a:outpath) : []
  silent! call delete(a:outpath)
  silent! call delete(a:inpath)
  call function(a:callback)(output)
endf

for s:ff_bin in ['fzy', 'sk', 'fzf', '']
  if executable(s:ff_bin)
    break
  endif
endfor

function! local#search#fuzzy(input, callback, prompt) abort
  if empty(s:ff_bin)
    return zeef#open(type(a:input) == 1 ? systemlist(a:input) : a:input, a:callback, a:prompt)
  endif

  let ff_cmds = {
        \ 'fzf':     "|fzf -m --height 15 --prompt '".a:prompt."> ' 2>/dev/tty",
        \ 'fzy':     "|fzy --lines=15 --prompt='".a:prompt."> ' 2>/dev/tty",
        \ 'sk':      "|sk -m --height 15 --prompt '".a:prompt."> '"
        \ }
  if s:env.is_win || s:env.is_cygwin
    let ff_cmds = {
          \ 'fzf': '|fzf -m ',
          \ 'fzy': "|fzy --lines=15 ",
          \ }
  endif
  let ff_cmd = ff_cmds[s:ff_bin]

  if type(a:input) ==# v:t_string
    let inpath = ''
    let cmd = a:input . ff_cmd
  else
    let inpath = tempname()
    call writefile(a:input, inpath)
    let cat_cmd = (s:env.is_win && !s:env.is_cygwin)
          \ ? 'type'
          \ : 'cat'
    let cmd  = cat_cmd . ' ' . fnameescape(inpath) . ff_cmd
  endif

  if !has('gui_running') && !s:env.is_cygwin && executable('tput') && filereadable('/dev/tty')
    let output = systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; ' . cmd, &lines))
    redraw!
    silent! call delete(inpath)
    call function(a:callback)(output)
    return
  endif

  let outpath = tempname()
  let cmd .= ' >' . fnameescape(outpath)

  if has('terminal')
    if !s:env.is_win && !s:env.is_cygwin
      botright 15split
    endif
    call term_start([&shell, &shellcmdflag, cmd], {
          \ 'term_name': a:prompt,
          \ 'curwin': 1,
          \ 'term_finish': 'close',
          \ 'exit_cb': function('s:get_ff_output', [inpath, outpath, a:callback])
          \ })
  else
   silent execute '!' . cmd
   redraw!
   call s:get_ff_output(inpath, outpath, a:callback, -1, v:shell_error)
  endif
endfunction

function! Local_set_arglist(paths) abort
  if empty(a:paths) | return | endif
  execute 'args' join(map(a:paths, 'fnameescape(v:val)'))
endfunction

function! local#search#fuzzy_arglist(input) abort
  call local#search#fuzzy(a:input, 'Local_set_arglist', 'Choose files')
endfunction

function! local#search#fuzzy_files(...) abort
  let dir = (a:0 > 0 ? ' '.a:1 : ' .')

  call local#search#fuzzy_arglist(executable('rg') ? 'rg --files' . dir : 'find' . dir . ' -type f')
endfunction

function! Local_switch_to_buffer(results) abort
  execute 'buffer' matchstr(a:results[0], '^\s*\zs\d\+')
endfunction

function! local#search#choose_buffer(props) abort
  let buffers = map(split(execute('ls' .. (get(a:props, 'unlisted', 0) ? '!' : '')), "\n"), 'substitute(v:val, ''"\(.*\)"\s*line\s*\d\+$'', ''\1'', "")')
  call local#search#fuzzy(buffers, 'Local_switch_to_buffer', 'Switch buffer')
endfunction
