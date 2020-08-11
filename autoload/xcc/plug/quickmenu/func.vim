let s:cmds = {}

fun! s:get_command_name(line) abort
  let cmd = matchstr(a:line, '\(\d\+)\s\+\)\@<=.\+')
  return cmd
endf

fun! s:run_command() abort
  let line = getline('.')
  wincmd q
  let cmdname = s:get_command_name(line)
  let cmd = s:get_command(cmdname)
  " echo 'Executing ' . cmd.name . ' => ' . cmd.command
  exec cmd.command
  " echo 'Done'
endf

fun! s:get_command(cmd) abort
  return s:cmds[a:cmd]
endf

fun! s:render() abort
  let index = 0
  for name in keys(s:cmds)
    let cmd = s:cmds[name]
    let index += 1
    let key = ''
    if index < 10
      let key = index
    else
      let key = nr2char(index - 10 + 97)
    endif

    let item_name = key . ') ' . get(cmd, 'name', name)
    cal append(line('$') , item_name)

    " echo item_name
    " echo 'nnoremap <buffer> ' . key . " :wincmd q<CR>:" . cmd['command'] . '<CR>'
    exec 'nnoremap <buffer> ' . key . ' :wincmd q<CR>:' . cmd['command'] . '<CR>'
  endfor
  normal! ggdd
  " nnoremap <buffer><script> <CR> :call <SID>get_command_name()<CR>
  nnoremap <buffer><script> <CR> :call <SID>run_command()<CR>
endf

if exists('g:quickmenu_cmds')
  let s:cmds = extend(s:cmds, g:quickmenu_cmds)
endif

fun! xcc#plug#quickmenu#func#add(cmd, config) abort
  let config = a:config
  let config['name'] = a:cmd
  let s:cmds[a:cmd] = config
endf

fun! xcc#plug#quickmenu#func#open() abort
  30vnew
  setlocal bufhidden=wipe buftype=nofile nonu fdc=0
  cal s:render()
  setlocal nomodifiable cursorline
endf
