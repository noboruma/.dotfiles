source ~/.vim/bundle/coding_activator.vim
packadd vim-typescript

set makeprg=tsc

"if !exists('g:LanguageClient_serverCommands')
"    let g:LanguageClient_serverCommands = {}
"endif
"let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
"let g:LanguageClient_serverCommands.javascript.jsx = ['tcp://127.0.0.1:2089']
"
"setlocal omnifunc=LanguageClient#complete
"let g:LanguageClient_autoStop = 0
"
exe "SemanticHighlightToggle"
