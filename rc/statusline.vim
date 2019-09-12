scriptencoding utf-8

function! MyStatusLine()
  return s:GetPaste()
        \. '%4*%{MyStatusGit()}%*'
        \. '%5*%{MyStatusGitChanges()}%* %{MyStatusCoc()} '
        \. "%6*%{get(b:, 'coc_current_function', '')}%*"
        \. ' %f %{MyStatusModifySymbol()}'
        \. ' %{MyStatusReadonly()}'
        \. '%=%-{&ft} %l,%c %P '
"%{&fenc}
endfunction

function! s:IsTempFile()
  if !empty(&buftype) | return 1 | endif
  if &previewwindow | return 1 | endif
  let filename = expand('%:p')
  if filename =~# '^/tmp' | return 1 | endif
  if filename =~# '^fugitive:' | return 1 | endif
  return 0
endfunction

function! s:GetPaste()
  if !&paste | return '' | endif
  return '%#MyStatusPaste# paste %*'
endfunction

function! MyStatusReadonly()
  if !&readonly | return '' | endif
  return '  '
endfunction

function! MyStatusCoc()
  if get(g:, 'did_coc_loaded', 0)
    return coc#status()
  endif
  return ''
endfunction

function! MyStatusAsyncrun()
  return get(g:, 'asyncrun_status', '')
endfunction

function! MyStatusModifySymbol()
  return &modified ? '⚡' : ''
endfunction

function! MyStatusGitChanges()
  if s:IsTempFile() | return '' | endif
  return get(b:, 'coc_git_status', '')
endfunction

function! MyStatusGit(...)
  let status = get(g:, 'coc_git_status', '')
  return empty(status) ? '' : '  '.status.' '
endfunction

function! SetStatusLine()
  if &previewwindow | return | endif
  if s:IsTempFile() | return | endif
  setlocal statusline=%!MyStatusLine()
  hi User6         guifg=#fe8019 guibg=#282828 gui=none
  hi User3         guifg=#e03131 guibg=#111111 gui=none
  hi MyStatusPaste guifg=#F8F8F0 guibg=#FF5F00 gui=none
  hi MyStatusPaste ctermfg=202   ctermbg=16    cterm=none
  hi User4 guifg=#f8f8ff guibg=#000000
  hi User5 guifg=#f8f9fa guibg=#343a40
endfunction

augroup vimrc_statusline
  autocmd!
  autocmd BufEnter,BufNewFile,BufReadPost,ShellCmdPost,BufWritePost * call SetStatusLine()
  autocmd FileChangedShellPost,ColorScheme * call SetStatusLine()
augroup end

"
" tabline
"
if !exists('g:my_tabline_style')
  let g:my_tabline_style = 0
endif

function! MyTabLine()
  let s = ''

  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif

  return s
endfunction

function! MyTabBufferName(bufnr, fullname)
  let name = bufname(a:bufnr)
  if getbufvar(a:bufnr, '&modifiable')
    if name ==# ''
      return '[No Name]'
    else
      if a:fullname
        return fnamemodify(name, ':p')
      else
        let aname = fnamemodify(name, ':p')
        let sname = fnamemodify(aname, ':t')
        if sname ==# ''
          let test = fnamemodify(aname, ':h:t')
          if test !=# ''
            return '<'. test . '>'
          endif
        endif
        return sname
      endif
    endif
  else
    let buftype = getbufvar(a:bufnr, '&buftype')
    if buftype ==? 'quickfix'
      return '[Quickfix]'
    elseif name !=# ''
      if a:fullname
        return '-'.fnamemodify(name, ':p')
      else
        return '-'.fnamemodify(name, ':t')
      endif
    else
    endif
    return '[No Name]'
  endif
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let fname = MyTabBufferName(bufnr, 0)
  let num = a:n

  if g:my_tabline_style == 0
    return fname
  elseif g:my_tabline_style == 1
    return '['.num.'] '.fname
  elseif g:my_tabline_style == 2
    return ''.num.' - '.fname
  endif

  if getbufvar(bufnr, '&modified')
    return '['.num.'] '.fname.' +'
  endif
  return '['.num.'] '.fname
endfunction

set showtabline=1
set tabline=%!MyTabLine()
