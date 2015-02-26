" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter,BufNewFile <buffer> :SemanticHighlightToggle
endif


setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=5

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap { {<CR>}<Esc>ko

map <F1> :update all<cr><f5><cr>
