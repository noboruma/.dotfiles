packadd vim-slime
packadd vim-ruby

source ~/.vim/bundle/coding_activator.vim

" activated with 'solargraph socket'
if !exists('g:LanguageClient_serverCommands')
    let g:LanguageClient_serverCommands = {}
endif
let g:LanguageClient_serverCommands.ruby = ['tcp://localhost:7658']

setlocal omnifunc=LanguageClient#complete
let g:LanguageClient_autoStop =0
