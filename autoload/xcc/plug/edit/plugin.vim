command! -nargs=? EV call xcc#plug#edit#EV#commander(<f-args>)

command! -nargs=* E call xcc#plug#edit#ED#edit_another(<f-args>)
command! -nargs=* D call xcc#plug#edit#ED#edit_in_another(<f-args>)
command! -nargs=1 -complete=tag Dtag call xcc#plug#edit#ED#tag_in_another(<q-args>)
command! Dpop call xcc#plug#edit#ED#pop_in_another()
command! -nargs=? Dcopy call xcc#plug#edit#ED#copy_to_another(<q-args>)
command! -nargs=? Dmove call xcc#plug#edit#ED#move_to_another(<q-args>)

nnoremap <Space>e :E<CR>
nnoremap <Space>E :D<CR>

nnoremap <C-w><C-]> :Dtag <C-R>=expand('<cword>')<CR><CR>
nnoremap <C-w><C-t> :Dpop<CR>

nnoremap <Space>p :Dcopy<CR>
nnoremap <Space>P :Dmove<CR>
vnoremap <Space>p :<C-u>Dcopy v<CR>
vnoremap <Space>P :<C-u>Dmove v<CR>

function! xcc#plug#edit#plugin#load() abort
  return 1
endfunction
