" CPP config is shared with C one (c.vim)

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight
  au BufWritePost <buffer> :SemanticHighlight
endif

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

"inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>
inoremap <<cr> <<cr>><c-o>O<tab>

"Makeprg erroformat
"compiler gcc
"! see c.vim for efm
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
setlocal foldmethod=expr
setlocal foldexpr=CFold1Lay()

" Stop parsing include files
setlocal complete-=i
" stop use ctags, only used for jump
setlocal complete-=t

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

function! CppNoNamespaceAndTemplateIndent()
    let l:cline_num = line('.')
    let l:cline = getline(l:cline_num)
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    while l:pline =~# '\(^\s*//\|^\s*/\*\|\*/\s*$\)'
        let l:pline_num = prevnonblank(l:pline_num - 1)
        let l:pline = getline(l:pline_num)
    endwhile
    let l:retv = cindent('.')
    let l:pindent = indent(l:pline_num)
    if l:pline =~# '^\s*.*\s*<\s*.*\s*,\s*$'
        echom 'first'
        let l:left= strlen(substitute(l:pline, "[^<]", "","g"))
        let l:right = strlen(substitute(l:pline, "[^>]", "","g"))
        if l:left > l:right
            let l:match = matchstrpos(l:pline,'<')
            let l:retv = l:match[2]
        else
            let l:retv = l:pindent
        endif
    elseif l:pline =~# '^\s*.*\s*>\s*\(,\|\)\s*$'
        "Ok let search for the indent before the template
        let l:left= strlen(substitute(l:pline, "[^<]", "","g"))
        let l:right = strlen(substitute(l:pline, "[^>]", "","g"))
        if l:left == l:right
            let l:retv = l:pindent
        else
            let l:pline_num = prevnonblank(l:pline_num - 1)
            let l:pline = getline(l:pline_num)
            let l:ppindent = indent(l:pline_num)
            if l:pindent == 0
                let l:retv = l:pindent
            else
                while (l:pindent <= l:ppindent)
                    let l:pline_num = prevnonblank(l:pline_num - 1)
                    let l:pline = getline(l:pline_num)
                    let l:ppindent = indent(l:pline_num)
                endwhile
                let l:retv = l:ppindent
            endif
        endif
    endif
    return l:retv
endfunction

setlocal indentexpr=CppNoNamespaceAndTemplateIndent()
