" Adapt on save hook
autocmd BufWritePre <buffer> %s/\s\+$//e
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

"Makeprg erroformat
compiler gcc

let g:syntastic_c_compiler = 'gcc'
let g:syntastic_cpp_config_file = '.syntastic_c_config'

" Surround 
let g:surround_{char2nr("c")} = "\/****\n\r\n****\/"

"setlocal foldlevel=1
"setlocal foldnestmax=1
"setlocal foldmarker={,}
"setlocal foldminlines=1
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
setlocal foldlevelstart=1


set expandtab
set tabstop=4
set shiftwidth=4

set complete-=i

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

inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

if !exists("*File_flip")
function! File_flip()
  if match(expand("%:t"),"\\.h") > 0
    let s:flipname = substitute(expand("%:t"),'\.h','.c',"")
    exe ":find " s:flipname
  elseif match(expand("%:t"),"\\.c") > 0
    let s:flipname = substitute(expand("%:t"),'\.c','.h',"")
    exe ":find " s:flipname
  endif
endfun
endif
