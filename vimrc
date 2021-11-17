" vimrc
"
" Author:   Larry Xu <hilarryxu@gmail.com>
" Updated:  2021/11/16
"
" This file changes a lot.

scriptencoding utf-8

function! VimrcEnvironment()
  let env = {}
  let env.is_mac = has('mac')
  let env.is_linux = has('unix') && !has('macunix') && !has('win32unix')
  let env.is_win = has('win32') || has('win64')

  let env.nvim = has('nvim') && exists('*jobwait') && !env.is_win
  let env.vim8 = exists('*job_start')
  let env.timer = exists('*timer_start')
  let env.tmux = !empty($TMUX)
  let env.gui = has('gui_running')
  let env.has_python = has('python') || has('python3')

  let user_dir = env.is_win
        \ ? expand('$VIM/vimfiles')
        \ : expand('~/.vim')
  let undo_dir_name = env.nvim
        \ ? 'nvim_undo'
        \ : 'undo'

  let env.path = {
        \   'user':        user_dir,
        \   'plugins':     user_dir . '/plugins',
        \   'data':        user_dir . '/data',
        \   'local_vimrc': user_dir . '/.vimrc_local',
        \   'tmp':         user_dir . '/tmp',
        \   'undo':        user_dir . '/data/' . undo_dir_name,
        \   'plug_path':   user_dir . '/plugged',
        \ }

  return env
endfunction

let s:env = VimrcEnvironment()
let $VIMHOME = s:env.path.user
let g:vimrc_env = s:env

if s:env.nvim
  set runtimepath+=$HOME/.vim
endif

if has('gui_running') && s:env.is_win
  let $LANG = 'en'
  set langmenu=en
endif

function! s:load_rc(name) abort
  execute 'source ' . s:env.path.user . '/rc/' . a:name . '.vim'
endfunction

function! HasPlug(name) abort
  return index(g:plugs_order, a:name) >= 0
endfunction

if !s:env.is_win
  silent! call plug#begin(s:env.path.plug_path)
  call s:load_rc('plug')
  call plug#end()
endif

call s:load_rc('sensible')
call s:load_rc('functions')
call s:load_rc('options')
call s:load_rc('statusline')
call s:load_rc('completion')
call s:load_rc('plugins')
call s:load_rc('commands')
call s:load_rc('mappings')
call s:load_rc('autocmds')
call s:load_rc('abbr')

if filereadable(s:env.path.local_vimrc)
  execute 'source ' . s:env.path.local_vimrc
else
  call s:load_rc('local_rc')
endif

if has('gui_running') && s:env.is_win
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" vim:set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker
