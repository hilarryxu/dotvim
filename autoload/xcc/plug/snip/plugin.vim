noremap <Space>e- :call xcc#plug#snip#func#comment_block('-')<CR>
noremap <Space>e= :call xcc#plug#snip#func#comment_block('=')<CR>
noremap <Space>e# :call xcc#plug#snip#func#comment_block('#')<CR>
noremap <Space>ec :call xcc#plug#snip#func#copyright('Larry Xu')<CR>
noremap <Space>el :call xcc#plug#snip#func#modeline()<CR>
noremap <Space>et "=strftime("%Y/%m/%d %H:%M:%S")<CR>gp

function! xcc#plug#snip#plugin#load() abort
  return 1
endfunction
