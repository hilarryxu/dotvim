" ==== Search Window Class =========================================== {{{
" Author:  Cornelius (林佑安)
" Author: Larry Xu
" Version: 0.5

fun! s:echo(msg)
  redraw
  echomsg a:msg
endf

" search window manager
let s:swindow = {
      \ 'buf_nr' : -1 ,
      \ 'mode' : 0 ,
      \ 'predefined_index': [] ,
      \ 'max_result': 100
      \ }

let s:swindow.loaded = 1
let s:swindow.version = 0.5

fun! s:swindow.open(pos, type, size)
  call self.split(a:pos, a:type, a:size)
endf

fun! s:swindow.split(position, type, size)
  if !bufexists(self.buf_nr)
    if a:type == 'split' | let act = 'new'
    elseif a:type == 'vsplit' | let act = 'vnew'
    else | let act = 'new' | endif

    let self.win_type = a:type

    exec a:position . ' ' . a:size . act
    let self.buf_nr = bufnr('%')

    cal self._init_buffer()
    cal self.init_buffer()
    cal self.init_syntax()
    cal self.init_basic_mapping()
    cal self.init_mapping()

    let self.predefined_index = self.index()
    cal self.update_search()

    cal self.start()
  elseif bufwinnr(self.buf_nr) == -1
    exec a:position . ' ' . a:size . a:type
    execute self.buf_nr . 'buffer'
    cal self.buffer_reload_init()
  elseif bufwinnr(self.buf_nr) != bufwinnr('%')
    execute bufwinnr(self.buf_nr) . 'wincmd w'
    cal self.buffer_reload_init()
  endif
endf

fun! s:swindow.index()
  return []
endf

fun! s:swindow.update()
  call self.update_search()
  call self.update_highlight()
  startinsert
endf

fun! s:swindow.update_search()
  let pattern = self.get_pattern()
  let lines = self.filter_result(pattern, self.predefined_index)
  if len(lines) > self.max_result
    let lines = remove(lines, 0, self.max_result)
  endif
  call self.render(lines)
endf

fun! s:swindow.update_highlight()
  let pattern = self.get_pattern()
  if strlen(pattern) > 0
    exec 'syn clear Search'
    exec 'syn match Search +'. pattern . '+'
  else
    exec 'syn clear Search'
  endif
endf

" start():
" after a buffer is initialized , start() function will be called to
" setup.
fun! s:swindow.start()
  call cursor(1, 1)
  startinsert
endf

" buffer_reload_init()
" will be triggered after search window opened and the
" buffer is loaded back , which doesn't need to initiailize.
fun! s:swindow.buffer_reload_init()
endf

" _init_buffer()
" initialize newly created buffer for search window.
fun! s:swindow._init_buffer()
  setlocal noswapfile  buftype=nofile bufhidden=hide
  setlocal nobuflisted nowrap cursorline nonumber fdc=0
endf

fun! s:swindow.init_buffer()
endf

" init_syntax()
" setup the syntax for search window buffer
fun! s:swindow.init_syntax()
endf

" init_mapping()
" define your mappings for search window buffer
fun! s:swindow.init_mapping()
endf

" init_base_mapping()
" this defines default set mappings
fun! s:swindow.init_basic_mapping()
  imap <buffer>     <Enter> <ESC>j<Enter>
  imap <buffer>     <C-a>   <Esc>0i
  imap <buffer>     <C-e>   <Esc>A
  imap <buffer>     <C-b>   <Esc>i
  imap <buffer>     <C-f>   <Esc>a
  inoremap <buffer> <C-n> <ESC>j
  nnoremap <buffer> <C-n> j
  nnoremap <buffer> <C-p> k
  nnoremap <buffer> <ESC> <C-W>q
  nnoremap <buffer> q <C-W>q
  nnoremap <buffer> i ggA
endf

fun! s:swindow.filter_render(lines)
endf

" clear current buffer except pattern line
" re-render the result ( lines )
fun! s:swindow.render(lines)
  cal self.filter_render(a:lines)

  let old = getpos('.')
  if line('$') > 2
    silent 2,$delete _
  endif
  let r = join(a:lines, "\n")
  silent put=r
  call setpos('.', old)
endf

" override this if your pattern is on different line
fun! s:swindow.get_pattern()
  return getline(1)
endf

" reder_result()
" put list into buffer
fun! s:swindow.filter_result(ptn, list)
  return filter(copy(a:list), 'v:val =~ "' . a:ptn . '"')
endf

fun! s:swindow.close()
  " since we call buffer back , we dont need to remove buffername
  " silent 0f
  redraw
endf

let xcc#clz#swindow#class = s:swindow

" ==== Window Manager =========================================== }}}
