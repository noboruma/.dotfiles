source ~/.vim/bundle/coding_activator.vim

" Make options
if (&ft == 'c')
    let &makeprg='make'
    let g:make_extra='@ -j4 -O3 -C .'
endif

" Clang-format
packadd vim-clang-format
let g:clang_format#command="clang-format-3.5"
let g:clang_format#detect_style_file=0
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11",
            \ "BasedOnStyle": "Google",
            \ "IndentWidth": 4,
            \ "AccessModifierOffset": -2,
            \ "IndentCaseLabels": "false",
            \ "MaxEmptyLinesToKeep": 3,
            \ "KeepEmptyLinesAtTheStartOfBlocks": "true",
            \ "SpacesBeforeTrailingComments": 1,
            \ "AllowShortFunctionsOnASingleLine": "None",
            \ "DerivePointerAlignment": "false",
            \ "BinPackParameters": "false",
            \ "AllowAllParametersOfDeclarationOnNextLine": "false",
            \ "BreakConstructorInitializersBeforeComma": "true",
            \ "ConstructorInitializerAllOnOneLineOrOnePerLine": "false",
            \ "AllowShortIfStatementsOnASingleLine": "false",
            \ "AllowShortLoopsOnASingleLine": "false",
            \ "BreakBeforeBraces": "Linux",
            \ "ColumnLimit": 140,
            \ "NamespaceIndentation": "All"}
vnoremap <buffer><Leader>= :ClangFormat<CR>
" !Clang-format

"Makeprg erroformat
compiler gcc

" Surround
let g:surround_{char2nr("c")} = "\/*\r*\/"

let g:CFolderindent=0
if exists('debug')
    let g:CFolderClosed=99
else
    let g:CFolderClosed=1
endif

function! CFold1Lay()
    if getline(v:lnum) =~? '^\s*}$'
        if indent(v:lnum) == g:CFolderindent
            let g:CFolderClosed=1
            let g:CFolderindent=0
            return '<1'
        endif
    elseif getline(v:lnum) =~? '^\s*{$'
        if getline(v:lnum-1) =~? '^.*)$' || getline(v:lnum-1) =~? '^.*)\s*const$' || getline(v:lnum-1) =~? '^.*)\s*volatile$'
            if g:CFolderClosed == 1
                let g:CFolderClosed=0
                let g:CFolderindent=indent(v:lnum)
                return '>1'
            endif
        endif
    endif
    return '='
endfunction

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

inoremap ;; <esc>g_a;
inoremap ,, <esc>g_a,
inoremap ;. <esc>g_a.

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>

function SetDebug()
    let choice = confirm("Debug mode", "&Yes\n&No", 2)
    if choice == 0
    elseif choice == 1
        let g:debug=1
        let g:make_extra='@ -j4 DEBUG=1 -C .'
    elseif choice == 2
        let g:debug=1
        unlet g:debug
        let g:make_extra='@ -j4 -O3 -C .'
    endif
endfunction

noremap <expr> <F9> "<esc>:<c-u>call SetDebug()<cr>"

if !exists("*File_flip")
    function! File_flip()
        let oldpath=&path
        set path+=../**
        if match(expand("%:t"),"\\.h") > 0
            let s:flipname = substitute(expand("%:t"),'\.h','.c',"")
            exe ":find " s:flipname
        elseif match(expand("%:t"),"\\.c") > 0
            let s:flipname = substitute(expand("%:t"),'\.c','.h',"")
            exe ":find " s:flipname
        endif
        let &path=oldpath
    endfun
endif

set efm=%f:%l:%c:%m
set efm+=%Dmake:\ Entering\ directory\ '%f'
set efm+=%Xmake:\ Leaving\ directory\ '%f'
set efm+=%Dmake[%*\\d]:\ Entering\ directory\ '%f'
set efm+=%Xmake[%*\\d]:\ Leaving\ directory\ '%f'
set grepformat=%f:%l:%c:%m

DefineLocalTagFinder TagFindStruct s,struct
