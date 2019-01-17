packadd vim-javascript

source ~/.vim/bundle/coding_activator.vim

let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ }

set omnifunc=LanguageClient#complete
let g:LanguageClient_autoStop =0
