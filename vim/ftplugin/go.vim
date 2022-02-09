packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim

setlocal nolist
setlocal noexpandtab

let g:go_gopls_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_fmt_command = 'gofmt'
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
packadd vim-go

compiler go
let &makeprg='go build'

function! GoFormatBuffer()
    if &modifiable == 1
        let l:curw=winsaveview()
        let l:tmpname=tempname()
        call writefile(getline(1,'$'), l:tmpname)
        call system("gofmt " . l:tmpname ." > /dev/null 2>&1")
        if v:shell_error == 0
            try | silent undojoin | catch | endtry
            silent %!gofmt -tabwidth=4
        endif
        call delete(l:tmpname)
        call winrestview(l:curw)
    endif
endfunction

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
            elseif match(expand("%:t"),"\\.go") > 0
                let s:flipname = substitute(expand("%:t"),'\.go','_test\.go',"")
            endif
            exe ":find " s:flipname
        catch
            if match(expand("%:t"),"_test\\.go") > 0
                let s:flipname = substitute(expand("%:p"),'_test\.go','\.go',"")
            elseif match(expand("%:t"),"\\.go") > 0
                let s:flipname = substitute(expand("%:p"),'\.go','_test\.go',"")
            endif
            exe ":edit " s:flipname
        endtry
        let &path=oldpath
    endfun
endif
