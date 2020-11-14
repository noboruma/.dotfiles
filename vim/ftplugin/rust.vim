source ~/.vim/bundle/coding_activator.vim

packadd rust.vim
let g:rustfmt_autosave = 0

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits',
        \'i:impls,trait implementations',
    \]
\}

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
"
let g:make_extra='@ build -j4'

set expandtab
set tabstop=4
set shiftwidth=4

DefineLocalTagFinder TagFindStruct s,struct
DefineLocalTagFinder TagFindTrait t,trait

"let &efm = ''
"" Random non issue stuff
"let &efm .= '%-G%.%#aborting due to previous error%.%#,'
"let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'
"" Capture enter directory events for doc tests
"let &efm .= '%D%*\sDoc-tests %f%.%#,'
"" Doc Tests
"let &efm .= '%E---- %f - %o (line %l) stdout ----,'
"let &efm .= '%Cerror%m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'
"" Unit tests && `tests/` dir failures
"" This pattern has to come _after_ the doc test one
"let &efm .= '%E---- %o stdout ----,'
"let &efm .= '%Zthread %.%# panicked at %m\, %f:%l:%c,'
"let &efm .= '%Cthread %.%# panicked at %m,'
"let &efm .= '%+C%*\sleft: %.%#,'
"let &efm .= '%+Z%*\sright: %.%#\, %f:%l:%c,'
"" Compiler Errors and Warnings
"let &efm .= '%Eerror%m,'
"let &efm .= '%Wwarning: %m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'
