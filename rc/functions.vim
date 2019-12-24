function! V_vim_cmd(cmd) abort
  botright 10new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, split(execute(a:cmd), "\n"))
  normal! gg
endfunction

function! V_cmd(cmd, ...) abort
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

function! V_buffer_close() abort
  if winnr('$') > 1
    close
  else
    bd
  endif
endfunction

function! V_buffer_only() abort
  let bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > bl[0] ? 'confirm '.bl[0].',.-bd' : '') (bufnr('') < bl[-1] ? '|confirm .+,$bd' : '')
endfunction

function! V_strip_trailing_whitespaces() abort
  let winview = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(winview)
  redraw
  echomsg 'Trailing space removed!'
endfunction

function! V_tab_width(...) abort
  if a:0 > 0
    let twd = a:1 > 0 ? a:1 : 1
    let &l:tabstop = twd
    let &l:shiftwidth = twd
    let &l:softtabstop = twd
  endif
  echo &l:tabstop
endfunction

function! V_toggle_paste()
  if (&paste == 1)
    set nopaste
    echo 'Paste: nopaste'
  else
    set paste
    echo 'Paste: paste'
  endif
endfunction

function! V_toggle_background()
  if &background ==# 'light'
    set background=dark
  else
    set background=light
  endif
endfunction
