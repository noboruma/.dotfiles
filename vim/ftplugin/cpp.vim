" CPP config is shared with C one (c.vim)

" Plugins
packadd tagfinder
packadd mesonic
" !Plugins

" set nonumber relativenumber

" set keywordprg=cppman
command! -nargs=+ Man exe "!tmux split-window 'sr duckduckgo cppreference " . expand(<q-args>) . "'"

" Surround
let g:surround_{char2nr(">")} = "\1template: \1<\r>"

inoremap <<cr> <<cr>><c-o>O<tab>
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"


let &makeprg='meson compile'
"Makeprg erroformat
"! see c.vim for efm
if !exists("*File_flip")
    function! File_flip()
        let oldpath=&path
        set path+=../**
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
                try
                    let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','\.hh',"")
                    exe ":find ".s:flipname
                catch
                    let s:flipname = substitute(expand("%:t"),'\.h\(.*\)','\.hpp',"")
                    exe ":find ".s:flipname
                endtry
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
        let &path=oldpath
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

    let l:commas= strlen(substitute(l:pline, "[^,]", "","g"))
    let l:left= strlen(substitute(l:pline, "[^<]", "","g"))
    let l:right = strlen(substitute(l:pline, "[^>]", "","g"))

    if l:left > l:right
        let l:i=1
        while(l:i < l:left - l:right)
            let l:pline= substitute(l:pline, "<", "","")
            let l:i=l:i+1
        endwhile
        let l:i=1
        while(l:i < l:commas)
            let l:pline= substitute(l:pline, ",", "","")
            let l:i=l:i+1
        endwhile
        let l:match = matchstrpos(l:pline,'<')
        let l:matchcomma = matchstrpos(l:pline,',')
        if l:match[2] == strlen(l:pline) || l:matchcomma[2] == strlen(l:pline)
            let l:retv = l:match[2] + l:commas + l:left - 2
        endif
    elseif l:left < l:right
        let l:ppline = l:pline_num
        while l:left < l:right && indent(l:ppline_num) != 0
            let l:ppline_num = prevnonblank(l:ppline_num - 1)
            let l:ppline = getline(l:ppline_num)
            let l:left = l:left + strlen(substitute(l:ppline, "[^<]", "","g"))
        endwhile
        let l:retv = indent(l:ppline_num)
    endif
    return l:retv
endfunction

setlocal indentexpr=CppNoNamespaceAndTemplateIndent()

DefineLocalTagFinder TagFindClass c,class

setlocal tags+=$HOME/.tags/boost
setlocal tags+=$HOME/.tags/cppstd
setlocal tags+=$HOME/.tags/poco
setlocal tags+=$HOME/.tags/cppus
