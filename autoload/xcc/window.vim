" xcc#window#new {{{1
" bufname: the buffer you wish to open a window edit it
" size: the initial size of the window
" pos: 'left', 'right', 'top', 'bottom'
" nested: 0 or 1. if nested, the window will be created besides current window 
function xcc#window#new(bufname, size, pos, nested, callback)
  let winpos = ''
  if a:nested == 1
    if a:pos == 'left' || a:pos == 'top'
      let winpos = 'leftabove'
    elseif a:pos == 'right' || a:pos == 'bottom'
      let winpos = 'rightbelow'
    endif
  else
    if a:pos == 'left' || a:pos == 'top'
      let winpos = 'topleft'
    elseif a:pos == 'right' || a:pos == 'bottom'
      let winpos = 'botright'
    endif
  end

  let vcmd = ''
  if a:pos == 'left' || a:pos == 'right'
    let vcmd = 'vertical'
  endif

  " if the buffer already exists, reuse it. otherwise create a new buffer
  let bufnum = bufnr(a:bufname)
  let bufcmd = ''
  if bufnum == -1
    " create a new buffer
    let bufcmd = fnameescape(a:bufname)
  else
    " edit exists buffer
    " NOTE: '+' here is to make it work with other command 
    let bufcmd = '+b' . bufnum
  endif

  " create window
  silent execute winpos . ' ' . vcmd . ' ' . a:size . ' split ' .  bufcmd

  " init window 
  silent setlocal winfixheight
  silent setlocal winfixwidth

  call a:callback()
endfunction

" xcc#window#open {{{1
" bufname: the buffer you wish to open a window edit it
" size: the initial size of the window
" pos: 'left', 'right', 'top', 'bottom'
" nested: 0 or 1. if nested, the window will be created besides current window 
" focus: 0 or 1. if focus, we will move cursor to opened window
" callback: init callback when window created

function xcc#window#open(bufname, size, pos, nested, focus, callback)
  call xcc#window#new(a:bufname, a:size, a:pos, a:nested, a:callback)

  if a:focus == 0
    call xcc#window#goto_edit_window()
  endif
endfunction

" xcc#window#close {{{1
function xcc#window#close(winnr)
  if a:winnr == -1
    return
  endif

  " jump to the window
  exe a:winnr . 'wincmd w'

  try
    close
  catch /E444:/
    call xcc#msg#warn("Can not close last window")
  endtry

  " this will help BufEnter event correctly happend when we enter the edit window 
  doautocmd BufEnter
endfunction

" xcc#window#resize {{{1
function xcc#window#resize(winnr, pos, new_size)
  let vcmd = ''
  if a:pos == 'left' || a:pos == 'right'
    let vcmd = 'vertical'
  endif

  " jump to the window
  exe a:winnr . 'wincmd w'
  silent execute vcmd . ' resize ' . a:new_size
endfunction

" xcc#window#record {{{1
let s:last_editbuf_winid = -1
let s:last_editplugin_bufnr = -1

function xcc#window#record()
  let winnr = winnr()
  let bufopts = []
  " if this is plugin window and do not have {action: norecord} 
  if xcc#plugin#is_registered(winbufnr(winnr), bufopts)
    if index(bufopts, 'norecord') == -1
      let s:last_editplugin_bufnr = bufnr('%')
    endif
  else
    let s:last_editbuf_winid = win_getid()
  endif
endfunction

" xcc#window#dump {{{1
function xcc#window#dump() 
  echomsg "last edit window id = " . s:last_editbuf_winid
  echomsg "last edit buffer = " . bufname(xcc#window#last_edit_bufnr())
  echomsg "last edit plugin = " . bufname(s:last_editplugin_bufnr)
endfunction

" xcc#window#is_plugin_window {{{1
function xcc#window#is_plugin_window(winnr)
  return xcc#plugin#is_registered(winbufnr(a:winnr))
endfunction

" xcc#window#last_edit_bufnr {{{1
function xcc#window#last_edit_bufnr()
  return winbufnr(s:last_editbuf_winid)
endfunction

" xcc#window#check_if_autoclose {{{1
function xcc#window#check_if_autoclose(winnr)
  let bufopts = []
  if xcc#plugin#is_registered(winbufnr(a:winnr), bufopts)
    if index(bufopts, 'autoclose') != -1
      return 1
    endif
  endif
  return 0
endfunction

" xcc#window#goto_edit_window {{{1
function xcc#window#goto_edit_window()
  " if current window is edit_window, don't do anything
  let winnr = winnr()
  if !xcc#window#is_plugin_window(winnr)
    return
  endif


  " get winnr from winid
  let winnr = win_id2win(s:last_editbuf_winid)

  " if we have edit window opened, jump to it
  " if something wrong make you delete the edit window (such as :q)
  " we will try to search another edit window, 
  " if no edit window exists, we will split a new one and go to it.
  if winnr != -1 
    " no need to jump if we already here
    if winnr() != winnr
      exe winnr . 'wincmd w'
    endif
  else
    " search if we have other edit window
    let i = 1
    let winCounts = winnr('$')
    while i <= winCounts
      if !xcc#window#is_plugin_window(i)
        exe i . 'wincmd w'
        return
      endif
      let i = i + 1
    endwhile

    " split a new one and go to it 
    exec 'rightbelow vsplit' 
    exec 'enew' 
    let newBuf = bufnr('%') 
    set buflisted 
    set bufhidden=delete 
    set buftype=nofile 
    setlocal noswapfile 
    normal athis is the scratch buffer 
  endif
endfunction

" xcc#window#goto_plugin_window {{{1
function xcc#window#goto_plugin_window()
  " get winnr from bufnr
  let winnr = bufwinnr(s:last_editplugin_bufnr)

  if winnr != -1 && winnr() != winnr
    exe winnr . 'wincmd w'
  endif
endfunction

" xcc#window#switch_window {{{1
function xcc#window#switch_window()
  if xcc#window#is_plugin_window(winnr())
    call xcc#window#goto_edit_window()
  else
    call xcc#window#goto_plugin_window()
  endif
endfunction
