fun! s:worknote()
  let fn = '~/.config/worknote/' . strftime('%Y/%m-%d') . '.txt'
  exec 'edit ' . fn
endf

com! WorkNote :call s:worknote()
