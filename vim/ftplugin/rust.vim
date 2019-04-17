source ~/.vim/bundle/coding_activator.vim
packadd rust

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

set expandtab
set tabstop=4
set shiftwidth=4

DefineLocalTagFinder TagFindStruct s,struct
DefineLocalTagFinder TagFindTrait t,trait

if executable('rls')
    packadd LanguageClient-neovim
    let g:LanguageClient_diagnosticsEnable=0
    let g:LanguageClient_selectionUI='quickfix'
    "set formatexpr=LanguageClient_textDocument_rangeFormatting()
    setlocal omnifunc=LanguageClient#complete

    if !exists('g:LanguageClient_serverCommands')
        let g:LanguageClient_serverCommands = {}
    endif
    let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'nightly', 'rls']
endif
