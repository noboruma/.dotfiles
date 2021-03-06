let g:html_indent_inctags = "html,body,head"

" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap ;; <esc>g_a;

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
