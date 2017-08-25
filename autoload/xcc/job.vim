let s:winpos_map = {
      \ "T": "to ",  "t": "abo ", "B": "bo ",  "b": "bel ",
      \ "L": "to v", "l": "abo v", "R": "bo v", "r": "bel v"
      \ }

" Run a shell command and send its output to a new buffer.
" cmdline: the command to be executed (String or List);
" ...    : the position of the output window (see s:winpos_map).
function! xcc#job#to_buffer(cmdline, ...)
  let l:cmd = join(map(type(a:cmdline) == type("") ? split(a:cmdline) : a:cmdline, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  execute get(s:winpos_map, get(a:000, 0, "B"), "bo ")."new"
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute '%!'. l:cmd
  setlocal nomodifiable
  wincmd p
endfunction

" Asynchronously run a shell command and send its output to a buffer.
" cmdline: the command to be executed (String or List);
" ...    : the position of the output window (see s:winpos_map).
function! xcc#job#to_buffer_async(cmdline, ...)
  let l:job = xcc#job#start(
        \ map(type(a:cmdline) == type("") ? split(a:cmdline) : a:cmdline, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : expand(v:val)')
        \ )
  if bufwinnr(ch_getbufnr(l:job, "out")) < 0 " If the buffer is not visible
    execute get(s:winpos_map, get(a:000, 0, "B"), "bo ")."split +buffer".ch_getbufnr(l:job, "out")
    wincmd p
  endif
endfunction

" The first argument should be a List. The second (optional) argument is
" a callback function. The third (optional) argument is a List of additional
" arguments to pass to the callback.
function! xcc#job#start(cmd, ...)
  silent! bwipeout! STDOUT
  silent! bwipeout! STDERR
  return job_start(a:cmd, {
        \ "close_cb": "xcc#job#close_cb",
        \ "exit_cb": function(get(a:000, 0, "xcc#job#callback"), get(a:000, 1, [bufnr('%')])),
        \ "in_io": "null", "out_io": "buffer", "out_name": "[STDOUT]",
        \ "err_io": "buffer", "err_name": "[STDERR]" })
endfunction

function! xcc#job#close_cb(channel)
  call job_status(ch_getjob(a:channel)) " Trigger exit_cb's callback
endfunction

function! xcc#job#callback(bufnr, job, status)
  if a:status == 0
    call lf_msg#notice("Success!")
  else
    call lf_msg#err("Job failed.")
  endif
endfunction
