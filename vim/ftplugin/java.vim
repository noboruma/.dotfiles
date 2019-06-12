source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='nvm'

compiler ant

" Surround
let g:surround_{char2nr(">")} = "\1template: \1<\r>"

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>

inoremap <<cr> <<cr>><c-o>O<tab>
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"

" Surround
let g:surround_{char2nr("c")} = "\/*\r*\/"

set expandtab
set tabstop=4
set shiftwidth=4

" Stop parsing include files
setlocal complete-=i
" stop use ctags, only used for jump
setlocal complete-=t

setlocal foldlevel=1
setlocal foldnestmax=2

function! CFold1Lay()
    if getline(v:lnum) =~? '^\s*}$'
        return '<1'
    elseif getline(v:lnum-1) =~? '^.*)\s*{$'
        return '>1'
    endif
    return '='
endfunction

if &diff
    " keep default folding if diff'ing
else
    setlocal foldmethod=expr
    setlocal foldexpr=CFold1Lay()
endif
