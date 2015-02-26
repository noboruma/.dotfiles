autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter,BufNewFile <buffer> :SemanticHighlightToggle
endif


inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab

noremap <F1> :update all<cr>:!ipython %<cr>
noremap <F2> :update all<cr>:!ipython -i %<cr>

set complete-=i
