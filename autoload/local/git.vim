function! s:git(args, where) abort
  call local#run#cmd(['git'] + a:args, {'pos': a:where})
  setlocal nomodifiable
endfunction

function! local#git#diff() abort
  let ft = getbufvar('%', '&ft')
  let fn = expand('%:t')
  call s:git(['show', 'HEAD:./'.fn], 'rightbelow vertical')
  let &l:filetype = ft
  execute 'silent file' fn '[HEAD]'
  diffthis
  autocmd BufWinLeave <buffer> diffoff!
  wincmd p
  diffthis
endfunction
