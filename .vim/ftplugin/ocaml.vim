execute "source " . "~/.vim/syntax/ocp-indent.vim"

" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldminlines=5

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

map <F1> :update all<cr><f5><cr>
set textwidth=80
set colorcolumn=80
set shiftwidth=2
set tabstop=2
" ocp-indent with ocp-indent-vim
