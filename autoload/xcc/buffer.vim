" xcc#buffer#cmd {{{1
" Send the output of a Vim command to a new scratch buffer
function! xcc#buffer#cmd(excmd)
  botright new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap
  call append(0, split(xcc#capture(a:excmd), "\n"))
endfunction

" xcc#buffer#navigate {{{1
function! xcc#buffer#navigate(cmd)
  if xcc#window#is_plugin_window(winnr())
    call xcc#window#goto_edit_window()
  endif

  try
    silent execute a:cmd . '!'
  catch /E85:/
    call xcc#msg#warn("There is no listed buffer")
  endtry
endfunction

" xcc#buffer#record {{{1
let s:alt_edit_bufnr = -1
let s:alt_edit_bufpos = []

function! xcc#buffer#record()
  let bufnr = bufnr('%')
  if buflisted(bufnr) && bufloaded(bufnr)
        \ && !xcc#plugin#is_registered(bufnr('%'))
    let s:alt_edit_bufnr = bufnr
    let s:alt_edit_bufpos = getpos('.')
  endif
endfunction

" xcc#buffer#dump {{{1
function! xcc#buffer#dump()
  echomsg "last alt edit buffer = " . bufname(s:alt_edit_bufnr)
  echomsg "last alt edit buffer pos = " . string(s:alt_edit_bufpos)
endfunction

" xcc#buffer#to_alternate_edit_buf {{{1
function! xcc#buffer#to_alternate_edit_buf()
  if xcc#window#is_plugin_window(winnr())
    call xcc#msg#warn("Swap buffer in plugin window is not allowed")
    return
  endif

  let alt_bufnr = bufnr('#')

  if bufexists(alt_bufnr) && buflisted(alt_bufnr) && bufloaded(alt_bufnr)
        \ && !xcc#plugin#is_registered(bufnr(alt_bufnr))
    " NOTE: because s:alt_edit_bufnr.'b!' will invoke BufLeave event
    " and that will overwrite s:alt_edit_bufpos
    let record_alt_bufpos = deepcopy(s:alt_edit_bufpos)
    let record_alt_bufnr = s:alt_edit_bufnr
    silent execute alt_bufnr . 'b!'

    " only recover the pos when we record the write alt buffer pos
    if alt_bufnr == record_alt_bufnr
        silent call setpos('.', record_alt_bufpos)
    endif

    return
  endif

  " if we don't have alt buf, go for search next
  let cur_bufnr = bufnr('%')
  let num_bufs = bufnr('$')
  let i = cur_bufnr + 1
  while i <= num_bufs
    if buflisted(i)
      silent execute i . 'b!'
      return
    endif
    let i = i + 1
  endwhile
  let i = 0
  while i < cur_bufnr
    if buflisted(i)
      silent execute i . 'b!'
      return
    endif
    let i = i + 1
  endwhile

  call xcc#msg#warn("Can't swap to buffer " . fnamemodify(bufname(alt_bufnr), ":p:t") . ", buffer not listed.")
endfunction

" xcc#buffer#keep_window_bd {{{1
" Delete the buffer; keep windows; create a scratch buffer if no buffers left
function! xcc#buffer#keep_window_bd()
  if xcc#window#is_plugin_window(winnr())
    call xcc#msg#warn("Can't close plugin window by bd")
    return
  endif

  " if this our scratch buffer, do nothing
  if !bufname('%') && &bufhidden == 'delete' && &buftype == 'nofile'
    return
  endif

  " if the buffer didn't saved, warning it and return
  if getbufvar('%', '&mod')
    call xcc#msg#warn("Can not close: The buffer is unsaved.")
    return
  endif

  " get current buffer and window
  let bd_bufnr = bufnr('%')
  let cur_winnr = winnr()

  " count how manay buffer listed left
  let nr_buflisted = 0
  let nr_buf = bufnr('$')
  let i = 1
  while i <= nr_buf
    if i != bd_bufnr
      if buflisted(i)
        let nr_buflisted = nr_buflisted + 1
      endif
    endif
    let i = i + 1
  endwhile

  if !nr_buflisted
    silent execute 'enew'
    let new_bufnr = bufnr('%')
    set buflisted
    set bufhidden=delete
    set buftype=nofile
    setlocal noswapfile
    normal athis is the scratch buffer

    let i = 1
    let nr_win = winnr('$')
    while i <= nr_win
      if !xcc#window#is_plugin_window(i)
        execute i . 'wincmd w'
        execute 'b! ' . new_bufnr
      endif
      let i = i + 1
    endwhile
  else
    " search all edit window, if the window is using the buffer, try to
    " use alternate buffer
    let i = 1
    let winCounts = winnr('$')
    while i <= winCounts
      if !xcc#window#is_plugin_window(i)
        if winbufnr(i) == bd_bufnr
          exe i . 'wincmd w'
          let prev_bufnr = bufnr('#')
          if prev_bufnr > 0 && buflisted(prev_bufnr) && prev_bufnr != bd_bufnr
            b #
          else
            bn
          endif
        endif
      endif
      let i = i + 1
    endwhile
  endif

  " now delete the bd_bufnr
  execute cur_winnr . 'wincmd w'
  execute 'bd! ' . bd_bufnr
endfunction
