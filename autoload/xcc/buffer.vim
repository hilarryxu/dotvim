" Send the output of a Vim command to a new scratch buffer
function! xcc#buffer#cmd(excmd)
  botright new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap
  call append(0, split(xcc#capture(a:excmd), "\n"))
endfunction
