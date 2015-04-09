" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

setlocal spell spelllang=en,fr

noremap <F5> <esc>:w<cr>:!pdflatex %<cr>:!okular ./*.pdf<cr><cr>
inoremap <F5> <esc>:w<cr>:!pdflatex %<cr>:!okular ./*.pdf<cr><cr>
