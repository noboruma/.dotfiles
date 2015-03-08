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

map <F1> :update all<cr><f5><cr>

if !exists("*File_flip")
function! File_flip()
  let cpp_ext="cc"
  let hpp_ext="hh"
  " Switch editing between .c* and .h* files (and more).
  " Since .h file can be in a different dir, call find.
  if match(expand("%"),'\.'.cpp_ext.'') > 0
    let s:flipname = substitute(expand("%"),'\.'.cpp_ext.'\(.*\)','.'.hpp_ext.'\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),'\.hxx') > 0
    let s:flipname = substitute(expand("%"),'\.hxx\(.*\)','.hh\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.".hpp_ext."") > 0
    let s:flipname = substitute(expand("%"),'\.'.hpp_ext.'\(.*\)','.'.cpp_ext.'\1',"")
    try 
      exe ":find " s:flipname 
    catch 
      let s:flipname = substitute(expand("%"),'\.hh\(.*\)','.hxx\1',"")
      exe ":e " s:flipname
    endtry
  elseif match(expand("%"),"\\.h") > 0
    let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.c") > 0
    let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h\1',"")
    exe ":find " s:flipname
  endif
endfun
endif
