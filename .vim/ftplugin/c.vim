" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

"Makeprg erroformat
compiler gcc

" Surround 
let g:surround_{char2nr("c")} = "\/*\n\r\n*\/"

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=1

set complete-=i

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
inoremap ;; <esc>g_a;
inoremap ;. <esc>g_a.

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>

if !exists("*File_flip")
function! File_flip()
  if match(expand("%"),"\\.h") > 0
    let s:flipname = substitute(expand("%"),'\.h','.c',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.c") > 0
    let s:flipname = substitute(expand("%"),'\.c','.h',"")
    exe ":find " s:flipname
  endif
endfun
endif
