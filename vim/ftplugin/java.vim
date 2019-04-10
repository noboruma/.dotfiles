source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='nvm'

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

if &diff
    " keep default folding if diff'ing
else
    setlocal foldmethod=expr
    setlocal foldexpr=CFold1Lay()
endif

set expandtab
set tabstop=4
set shiftwidth=4

" Stop parsing include files
setlocal complete-=i
" stop use ctags, only used for jump
setlocal complete-=t


if executable('jdtls')
    let g:LanguageClient_diagnosticsEnable=1
    let g:LanguageClient_hasSnippetSupport=1
    let g:LanguageClient_selectionUI='quickfix'
    let g:LanguageClient_diagnosticsList='Location'
    if !exists('g:LanguageClient_serverCommands')
        let g:LanguageClient_serverCommands = {
                    \ 'java': ['$HOME/usr/bin/jdtls', '-data', getcwd()],
                    \ }
    else
        let g:LanguageClient_serverCommands.java = ['$HOME/usr/bin/jdtls', '-data', getcwd()]
    endif
    packadd LanguageClient-neovim
    "set formatexpr=LanguageClient_textDocument_rangeFormatting()
    setlocal omnifunc=LanguageClient#complete
    LanguageClientStart
else
    echom("jdtls not found")
endif
