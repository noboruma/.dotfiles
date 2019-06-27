source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='nvm'

compiler ant

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

set expandtab
set tabstop=4
set shiftwidth=4

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

if &diff
    " keep default folding if diff'ing
else
    setlocal foldmethod=expr
    setlocal foldexpr=CFold1Lay()
endif
