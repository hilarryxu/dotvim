if exists('b:did_xcc_python_ftplugin')
  finish
endif
let b:did_xcc_python_ftplugin = 1

setlocal foldmethod=indent textwidth=79

function! Xcc_DeferPlugPython(timer) abort
  call plug#load('python-mode')
  call plug#load('SimpylFold')
endfunction

nnoremap <buffer> <F5>            :<C-U>call xcc#lang#python#run()<CR>
nnoremap <buffer> <LocalLeader>=  :<C-U>call xcc#lang#python#fmt()<CR>
nnoremap <buffer> <LocalLeader>r  :<C-U>call xcc#lang#python#run()<CR>
nnoremap <buffer> <LocalLeader>cs :<C-U>call xcc#lang#python#stop()<CR>

if !exists('g:xcc_defer_plug_python_loaded')
  call timer_start(300, 'Xcc_DeferPlugPython')
  let g:xcc_defer_plug_python_loaded = 1
endif
