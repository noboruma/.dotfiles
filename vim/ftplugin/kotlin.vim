packadd kotlin-vim

source ~/.vim/bundle/coding_activator.vim

" Make options
compiler ant
let &makeprg='rbbmake'

setlocal noautochdir

function! StartDB()
    call vebugger#jdb#attach('9999')
    echom "jdb called"
endfunction

noremap <F4> :<c-u>AsyncRun -program=make -cwd=`brazil-path package-src-root`<tab>

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

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4

if !exists("*File_flip")
    function! File_flip()

        if expand('%') =~ "Test.kt"
            let s:flipname = substitute(expand('%:p'), 'tst', 'src', '')
            let s:flipname = substitute(s:flipname, 'Test\.kt', '\.kt', '')
        elseif expand('%') =~ ".kt"
            let s:flipname = substitute(expand('%:p'), 'src', 'tst', '')
            let s:flipname = substitute(s:flipname, 'src', 'tst', '')
            let s:flipname = substitute(s:flipname, 'tst', 'src', '')
            let s:flipname = substitute(s:flipname, '\.kt', 'Test\.kt', '')
        elseif expand('%') =~ "Test.java"
            let s:flipname = substitute(expand('%:p'), 'tst', 'src', '')
            let s:flipname = substitute(s:flipname, 'Test\.java', '\.java', '')
        elseif expand('%') =~ ".java"
            let s:flipname = substitute(expand('%:p'), 'src', 'tst', '')
            let s:flipname = substitute(s:flipname, 'src', 'tst', '')
            let s:flipname = substitute(s:flipname, 'tst', 'src', '')
            let s:flipname = substitute(s:flipname, '\.java', 'Test\.java', '')
        endif
        try "buffer opened but not reachable from path
            exe ":buffer ".s:flipname
        catch
            exe ":find ".s:flipname
        endtry
    endfun
endif

" Order matters
setlocal efm=\ \ \ \ \[javac\]\ %f:%l:%m
setlocal efm+=\[checkstyle\]\ \[ERROR\]\ %f:%l:%c:%m
setlocal efm+=\[checkstyle\]\ \[ERROR\]\ %f:%l:%m
setlocal efm+=%f:%l:%c:%m

exe "SemanticHighlightToggle"
