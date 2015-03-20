" Adapt on save hook
set shiftwidth=4
set tabstop=4
autocmd BufWritePre <buffer> silent! :Adapt

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

"setlocal foldlevel=1
"setlocal foldnestmax=1
"setlocal foldmarker={,}
"setlocal foldminlines=5

