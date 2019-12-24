" Find out to which highlight-group a particular keyword/symbol belongs
command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
      \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
      \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
      \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")

command! W w !sudo tee % > /dev/null
command! -complete=file -nargs=* Nrun :call s:Terminal(<q-args>)
command! -nargs=0 Save :call s:do_save()
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 Q :qa!
command! -nargs=0 Cd :call s:git_cd()
command! -nargs=0 Commits :CocList commits
command! -nargs=+ -complete=custom,s:grep_args Rg :exe 'CocList grep ' . <q-args>
command! -nargs=0 BufOnly :call s:buffer_only()
command! -complete=command -nargs=+ VimCmd call V_vim_cmd(<q-args>)
command! -nargs=? TabWidth call V_tab_width(<args>)

function! s:Terminal(cmd)
  execute 'belowright 5new'
  set winfixheight
  call termopen(a:cmd, {
        \ 'on_exit': function('s:OnExit'),
        \ 'buffer_nr': bufnr('%'),
        \})
  call setbufvar('%', 'is_autorun', 1)
  execute 'wincmd p'
endfunction

function! s:OnExit(job_id, status, event) dict
  if a:status == 0
    execute 'silent! bd! '.self.buffer_nr
  endif
endfunction

function! s:do_save() abort
  let file = $HOME . '/tmp.log'
  let content = getline(1, '$')
  call writefile(content, file)
endfunction

function! s:git_cd() abort
  if empty(get(b:, 'git_dir', '')) | return | endif
  execute 'cd ' . fnamemodify(b:git_dir, ':h')
endfunction

function! s:grep_args(...) abort
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

function! s:buffer_only() abort
  let bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > bl[0] ? 'confirm '.bl[0].',.-bd' : '') (bufnr('') < bl[-1] ? '|confirm .+,$bd' : '')
endfunction
