" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=5

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap { {<CR>}<Esc>ko

map <F1> :w<cr><f5><cr>
