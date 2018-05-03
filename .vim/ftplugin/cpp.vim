" CPP config is shared with C one (c.vim)

" Plugins
" OCC
let &runtimepath.=',~/.vim/bundle/OmniCppComplete'
set nocp
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.hxx,*.hh,*.cc set omnifunc=omni#cpp#complete#Main
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" !OCC
" Clang-format
let &runtimepath.=',~/.vim/bundle/vim-clang-format'
let g:clang_format#command="clang-format-3.5"
let g:clang_format#detect_style_file=0
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11",
            \ "BasedOnStyle": "Google",
            \"IndentWidth": 4,
            \"AccessModifierOffset": -2,
            \"IndentCaseLabels": "false",
            \"MaxEmptyLinesToKeep": 3,
            \"KeepEmptyLinesAtTheStartOfBlocks": "true",
            \"SpacesBeforeTrailingComments": 1,
            \"AllowShortFunctionsOnASingleLine": "None",
            \"DerivePointerAlignment": "false",
            \"BinPackParameters": "false",
            \"AllowAllParametersOfDeclarationOnNextLine": "false",
            \"BreakConstructorInitializersBeforeComma": "true",
            \"ConstructorInitializerAllOnOneLineOrOnePerLine": "false",
            \"AllowShortIfStatementsOnASingleLine": "false",
            \"AllowShortLoopsOnASingleLine": "false",
            \"BreakBeforeBraces": "Linux",
            \"ColumnLimit": 140,
            \"NamespaceIndentation": "All"}
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>= :ClangFormat<CR>
" !Clang-format
" !Plugins

" set keywordprg=cppman

" Surround
let g:surround_{char2nr(">")} = "\1template: \1<\r>"

inoremap <<cr> <<cr>><c-o>O<tab>
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

"Makeprg erroformat
"compiler gcc
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

DefineLocalTagFinder TagFindClass c,class

set tags+=$HOME/.tags/boost
set tags+=$HOME/.tags/cppstd
set tags+=$HOME/.tags/poco
set tags+=$HOME/.tags/cppus
