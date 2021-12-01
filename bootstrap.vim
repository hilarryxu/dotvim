if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8

function! s:detect_env()
  let env = {}
  let env.is_mac = has('mac')
  let env.is_linux = has('unix') && !has('macunix') && !has('win32unix')
  let env.is_win = has('win32') || has('win64')
  let env.is_cygwin = !empty($MINTTY_SHORTCUT) || !empty($MSYSTEM)

  let env.nvim = has('nvim') && exists('*jobwait') && !env.is_win
  let env.vim8 = exists('*job_start')
  let env.gui = has('gui_running')

  let user_dir = (env.is_win && !env.is_cygwin)
        \ ? expand('$VIM/vimfiles')
        \ : expand('~/.vim')
  let env.path = {
        \   'user':        user_dir,
        \   'local_vimrc': user_dir . '/.vimrc_local'
        \ }

  return env
endfunction

let s:env = s:detect_env()

let s:_vimrc = s:env.path.user . '/_vimrc'
if filereadable(s:_vimrc)
  execute 'source ' . s:_vimrc
endif
