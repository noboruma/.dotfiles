setlocal spell spelllang=en,fr

noremap <F1>:w<cr>:!pdflatex %<cr>:!okular ./*.pdf<cr><cr>
