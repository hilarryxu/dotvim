" Section: Commands

command! -buffer -nargs=1 Filter            call xcc#quickfix#filter('<args>', 'pattern', 0)
command! -buffer -nargs=1 FilterFile        call xcc#quickfix#filter('<args>', 'file', 0)
command! -buffer -nargs=1 ReverseFilter     call xcc#quickfix#filter('<args>', 'pattern', 1)
command! -buffer -nargs=1 ReverseFilterFile call xcc#quickfix#filter('<args>', 'file', 1)

" Section: Maps

nnoremap <silent> <buffer> <Localleader>r   :execute 'Filter ' . @/<CR>
nnoremap <silent> <buffer> <Localleader>fr  :execute 'FilterFile ' . @/<CR>
nnoremap <silent> <buffer> <Localleader>d   :execute 'ReverseFilter ' . @/<CR>
nnoremap <silent> <buffer> <Localleader>fd  :execute 'ReverseFilterFile ' . @/<CR>
nnoremap <silent> <buffer> <Localleader>u   :call xcc#quickfix#restore()<CR>
