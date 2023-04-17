source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='nvm'

compiler ant

setlocal noautochdir

function! StartDB()
    call vebugger#jdb#attach('9999')
    echom "jdb called"
endfunction


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

" Stop parsing include files
setlocal complete-=i
" stop use ctags, only used for jump
setlocal complete-=t


setlocal foldlevel=1
setlocal foldnestmax=2

function! CFold1Lay()
    if getline(v:lnum) =~? '^\s*}$'
        return '<1'
    elseif getline(v:lnum-1) =~? '^.*)\s*{$'
        return '>1'
    endif
    return '='
endfunction

if !exists("*File_flip")
    function! File_flip()
        if expand('%') =~ "Test.java"
            let s:flipname = substitute(expand('%:p'), 'tst', 'src', '')
            let s:flipname = substitute(s:flipname, 'Test\.java', '\.java', '')
        else
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

function! CppNoNamespaceAndTemplateIndent()
    let l:retv = cindent('.')
    let l:cline_num = line('.')
    let l:cline = getline(l:cline_num)
    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    let l:last_equal = stridx(l:pline, ' =')
    if l:last_equal != -1 && l:retv < l:last_equal && stridx(l:pline, ';') == -1 && stridx(l:pline, '//') == -1
        let l:retv = l:last_equal + 2 + 1
    endif
    " go up until non blank
    while l:pline =~# '\(^\s*//\|^\s*/\*\|\*/\s*$\)'
        let l:pline_num = prevnonblank(l:pline_num - 1)
        let l:pline = getline(l:pline_num)
    endwhile
    "let l:pindent = indent(l:pline_num)

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

"setlocal indentexpr=CppNoNamespaceAndTemplateIndent()
"Take care of indents for Java.
setlocal autoindent
setlocal si
setlocal shiftwidth=4
"Java anonymous classes. Sometimes, you have to use them.
setlocal cinoptions+=j1

if &diff
    " keep default folding if diff'ing
else
    "setlocal foldmethod=expr
    "setlocal foldexpr=CFold1Lay()
endif

" Order matters
setlocal efm=\[checkstyle\]\ \[ERROR\]\ %f:%l:%c:%m
setlocal efm+=\[checkstyle\]\ \[ERROR\]\ %f:%l:%m
setlocal efm+=%f:%l:%c:%m

" For some reasons, need to turn that off
"filetype indent off
"setlocal cino+=(0,b1,+0,t0,<0,j1      " C file option

exe "SemanticHighlightToggle"
