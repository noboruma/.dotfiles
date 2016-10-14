" CPP config is shared with C one (c.vim)
" Adapt on save hook
autocmd BufWritePre <buffer> %s/\s\+$//e
autocmd BufWritePre <buffer> silent! :Adapt

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight 
  au BufWritePost <buffer> :SemanticHighlight
endif

let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++1y'

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" Surround 
let g:surround_{char2nr("c")} = "\/*\n\r\n*\/"

"Makeprg erroformat
compiler gcc

setlocal foldlevel=1
setlocal foldnestmax=1
setlocal foldmarker={,}
setlocal foldminlines=1

" Stop parsing include files, use ctags instead
set complete-=i

"inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

if !exists("*File_flip")
  function! File_flip()
    " The flip mechanism consider that path is properly set on headers
    if match(expand("%"),'\.h\(.*\)') > 0
        if match(expand("%"),'\.hh') > 0
          try
            let s:flipname = substitute(expand("%"),'\.hh','\.hxx',"")
            exe ":find ".s:flipname
          catch
            let s:flipname = substitute(expand("%"),'\.hh','\.cc',"")
            try
              exe ":find ".s:flipname
            catch "buffer opened but not reachable from path
              exe ":buffer ".s:flipname
            endtry
          endtry
        elseif match(expand("%"),'\.hxx') > 0
          let s:flipname = substitute(expand("%"),'\.h\(.*\)','\.hh',"")
          exe ":find ".s:flipname
        else
          let s:flipname = substitute(expand("%"),'\.h\(.*\)','\.c\1',"")
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
    elseif match(expand("%"),'\.c\(.*\)') > 0
        if match(expand("%"),'\.cc') > 0
          try
            let s:flipname = substitute(expand("%"),'\.cc','\.hh',"")
            exe ":find ".s:flipname
          catch
            let s:flipname = substitute(expand("%"),'\.cc','\.hpp',"")
            exe ":find ".s:flipname
          endtry
        else
          let s:flipname = substitute(expand("%"),'\.c\(.*\)','\.h\1',"")
          exe ":find ".s:flipname
        endif
    endif
  endfun
endif
