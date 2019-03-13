packadd vim-slime
source ~/.vim/bundle/coding_activator.vim

let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.python =['pyls']
set omnifunc=LanguageClient#complete

setlocal expandtab
setlocal nolisp
setlocal autoindent

autocmd BufWritePre <buffer> silent! :Adapt

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab

nnoremap <leader>! :w<cr>:!python %<cr>
nnoremap <leader>!! :update all<cr>:!ipython -i %<cr>
nnoremap ;b Oimport pdb; pdb.set_trace()<esc>

set complete-=i
