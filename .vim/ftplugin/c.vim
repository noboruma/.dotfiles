" Adapt on save hook
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufNewFile,BufEnter <buffer> :SemanticHighlight
endif

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=5

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap { {<CR>}<Esc>ko

if !exists("*File_flip")
function! File_flip()
  if match(expand("%"),"\\.h") > 0
    let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.c") > 0
    let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h\1',"")
    exe ":find " s:flipname
  endif
endfun
endif
