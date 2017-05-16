" CPP config is shared with C one (c.vim)

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

" Surround 
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

"Makeprg erroformat
compiler gcc

let g:CFolderindent=0
let g:CFolderClosed=1
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
setlocal foldmethod=expr
setlocal foldexpr=CFold1Lay()
setlocal foldlevel=0
setlocal foldlevelstart=0

" Stop parsing include files
set complete-=i
" stop use ctags, only used for jump
set complete-=t

if !exists("*File_flip")
  function! File_flip()
    " The flip mechanism consider that path is properly set on headers
    if match(expand("%:t"),'\.h\(.*\)') > 0
        if match(expand("%:t"),'\.hh') > 0
          try
            let s:flipname = substitute(expand("%:t"),'\.hh','\.hxx',"")
            exe ":find ".s:flipname
          catch
            let s:flipname = substitute(expand("%:t"),'\.hh','\.cc',"")
            try "buffer opened but not reachable from path
              exe ":buffer ".s:flipname
            catch 
              exe ":find ".s:flipname
            endtry
          endtry
        elseif match(expand("%:t"),'\.hxx') > 0
          let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','\.hh',"")
          exe ":find ".s:flipname
        else
          let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','\.c\1',"")
          try "buffer opened but not reachable from path
            exe ":buffer ".s:flipname
            catch
                try
                  exe ":find ".s:flipname
                catch 
                  exe ":find ../../../src/".s:flipname
                endtry
          endtry
        endif
    elseif match(expand("%:t"),'\.c\(.*\)') > 0
        if match(expand("%:t"),'\.cc') > 0
          try
            let s:flipname = substitute(expand("%:t"),'\.cc','\.hh',"")
            exe ":find ".s:flipname
          catch
            let s:flipname = substitute(expand("%:t"),'\.cc','\.hpp',"")
            exe ":find ".s:flipname
          endtry
        else
          let s:flipname = substitute(expand("%:t"),'\.c\(.*\)','\.h\1',"")
          exe ":find ".s:flipname
        endif
    endif
  endfun
endif

set errorformat-=%f:%l:%m
