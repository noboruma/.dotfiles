source ~/.vim/bundle/coding_activator.vim

" LC
" See ftplugin for tools setup
if executable('ccls') || executable ('cquery')
    let g:LanguageClient_diagnosticsEnable=0
    let g:LanguageClient_selectionUI='quickfix'
    let g:LanguageClient_serverCommands = {}
    if executable('ccls')
        let g:LanguageClient_serverCommands.cpp = ['ccls',
                    "\ '--log-file=/tmp/cq.log',
                    \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}']
    elseif executable('cquery')
        let g:LanguageClient_serverCommands.cpp = ['cquery',
                    \ '--init={"cacheDirectory":"/tmp/cquery/cache/", "diagnostics": {"onParse": false, "onType": false}, "index": {"comments": 2}, "cacheFormat": "msgpack", "completion": {"filterAndSort": false}}']
    else
        echom 'no ccls nor cquery executable'
    endif
    packadd LanguageClient-neovim
    "set formatexpr=LanguageClient_textDocument_rangeFormatting()
    setlocal omnifunc=LanguageClient#complete
    LanguageClientStart
endif
" !LC

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


inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
inoremap ;; <esc>g_a;
inoremap ,, <esc>g_a,
inoremap ;. <esc>g_a.

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>


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
"set efm+=%f:%l:%c:%m
set efm+=%Dmake:\ Entering\ directory\ '%f'
set efm+=%Xmake:\ Leaving\ directory\ '%f'
set efm+=%Dmake[%*\\d]:\ Entering\ directory\ '%f'
set efm+=%Xmake[%*\\d]:\ Leaving\ directory\ '%f'
set grepformat=%f:%l:%c:%m

DefineLocalTagFinder TagFindStruct s,struct
