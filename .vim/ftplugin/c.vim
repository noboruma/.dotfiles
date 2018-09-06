if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

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

set efm=%f:%l:%c:\ %m
set efm+=%f:%l:%c:%m
set efm+=%Dmake:\ Entering\ directory\ '%f'
set efm+=%Xmake:\ Leaving\ directory\ '%f'
set efm+=%Dmake[%*\\d]:\ Entering\ directory\ '%f'
set efm+=%Xmake[%*\\d]:\ Leaving\ directory\ '%f'
set grepformat=%f:%l:%c:%m

DefineLocalTagFinder TagFindStruct s,struct
