let g:html_indent_inctags = "html,body,head"

" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap ;; <esc>g_a;

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
