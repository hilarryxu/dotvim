augroup vimrc_autocmds
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
        \   exe "normal! g`\"" |
        \ endif
  autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTICE\|WARNING\|DANGER\)')
augroup END

augroup vimrc_filetype
  autocmd!
  autocmd FileType vim setlocal shiftwidth=2 tabstop=2 softtabstop=2 foldmethod=marker
  autocmd FileType python setlocal omnifunc=
  autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nolist
  autocmd FileType c,cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 cinoptions=:0
  autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType less setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 foldmethod=syntax
  autocmd FileType mako setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType vue setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType sql setlocal omnifunc=
  autocmd FileType coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END
