source ~/.vim/bundle/coding_activator.vim
packadd rust.vim

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

inoremap <expr> ' "\'"
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>
inoremap <<cr> <<cr>><c-o>O<tab>

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
noremap <F4>  :botright copen\|AsyncRun -program=make @ build -j4
noremap <F5>  :botright copen\|AsyncRun -program=make @ build -j4<cr>

set expandtab
set tabstop=4
set shiftwidth=4

DefineLocalTagFinder TagFindStruct s,struct
DefineLocalTagFinder TagFindTrait t,trait

" Ignored patterns, and blank lines
set efm=%-G
set efm+=%-Gerror:\ aborting\ %.%#
set efm+=%-Gerror:\ Could\ not\ compile\ %.%#

" Meaningful lines (errors, notes, warnings, contextual information)
set efm+=%Eerror:\ %m
set efm+=%Eerror[E%n]:\ %m
set efm+=%Wwarning:\ %m
set efm+=%Inote:\ %m
set efm+=%C\ %#-->\ %f:%l:%c
