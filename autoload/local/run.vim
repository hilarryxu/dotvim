function! local#run#vim_cmd(cmd) abort
  botright 10new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, split(execute(a:cmd), "\n"))
  normal! gg
endfunction

function! local#run#cmd(cmd, ...) abort
  let opt = get(a:000, 0, {})
  if !has_key(opt, 'cwd')
    let opt['cwd'] = fnameescape(expand('%:p:h'))
  endif

  let cmd = join(map(a:cmd, 'v:val !~# "\\v^[%#<]" || expand(v:val) ==# "" ? v:val : shellescape(expand(v:val))'))
  execute get(opt, 'pos', 'botright') 'new'
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <buffer> q <C-w>c
  execute 'lcd' opt['cwd']
  execute '%!' cmd
endfunction
