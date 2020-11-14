source ~/.vim/bundle/coding_activator.vim

set nolist
set noexpandtab

compiler go
let &makeprg='go build'

let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
                \ 'p:package',
                \ 'i:imports:1',
                \ 'c:constants',
                \ 'v:variables',
                \ 't:types',
                \ 'n:interfaces',
                \ 'w:fields',
                \ 'e:embedded',
                \ 'm:methods',
                \ 'r:constructor',
                \ 'f:functions'
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
                    \ 't' : 'ctype',
                \ 'n' : 'ntype'
            \ },
            \ 'scope2kind' : {
                    \ 'ctype' : 't',
                \ 'ntype' : 'n'
            \ },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
        \ }

function DebugNearest()
    let nearestTest=execute('TagbarCurrentTag')
    call vimspector#LaunchWithSettings({"configuration": "test", "testName": "".nearestTest })
endfunction

command! DebugNearest call DebugNearest()
command! GoCheck AsyncRun golangci-lint run --tests=false

let test#go#gotest#options = {
      \ 'all':   '-v',
\}

if !exists("*File_flip")
    function! File_flip()
        let oldpath=&path
        set path+=./**
        try
            if match(expand("%:t"),"_test\\.go") > 0
                let s:flipname = substitute(expand("%:t"),'_test\.go','\.go',"")
                exe ":find " s:flipname
            elseif match(expand("%:t"),"\\.go") > 0
                let s:flipname = substitute(expand("%:t"),'\.go','_test\.go',"")
                exe ":find " s:flipname
            endif
        catch
            echohl ErrorMsg | echo "/!\\ Could not find matching file"
        endtry
        let &path=oldpath
    endfun
endif
