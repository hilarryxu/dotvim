let s:env = g:vimrc_env

if s:env.nvim
  " let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

  " let g:ycm_add_preview_to_completeopt = 0
  " let g:ycm_show_diagnostics_ui = 0
  " let g:ycm_server_log_level = 'info'
  " let g:ycm_min_num_identifier_candidate_chars = 2
  " let g:ycm_collect_identifiers_from_comments_and_strings = 1
  " let g:ycm_complete_in_strings = 1
  " let g:ycm_key_invoke_completion = '<c-z>'
  " " set completeopt=menu,menuone

  " noremap <c-z> <NOP>

  " let g:ycm_semantic_triggers = {
  "       \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
  "       \ 'cs,lua,javascript': ['re!\w{2}'],
  "       \ }

  " let g:ycm_filetype_whitelist = {
  "       \ 'c': 1,
  "       \ 'cpp': 1,
  "       \ 'python': 1,
  "       \ }
elseif s:env.is_win
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1

  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#sources#omni#min_keyword_length = 3

  let g:neocomplete#max_list = 8
  let g:neocomplete#sources#buffer#max_keyword_width = 30

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  " let g:neocomplete#sources#omni#input_patterns.python = ''

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  " let g:neocomplete#force_omni_input_patterns.css = '^\s\+\k\+\|\w\+[):;]\?\s\+\k*\|[@!]'


  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"


  augroup completion_omni
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
endif
