noremap <Space>e- :call xcc#plug#snip#func#comment_block('-')<CR>
noremap <Space>e= :call xcc#plug#snip#func#comment_block('-')<CR>
noremap <Space>e# :call xcc#plug#snip#func#comment_block('-')<CR>

function! xcc#plug#snip#plugin#load() abort
  return 1
endfunction
