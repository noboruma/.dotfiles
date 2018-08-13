"setlocal foldlevel=99
setlocal foldmethod=expr
setlocal foldexpr=matchstr(substitute(getline(v:lnum),'\|.*','',''),'^.*/')==#matchstr(substitute(getline(v:lnum+1),'\|.*','',''),'^.*/')?1:'<1'
setlocal foldtext=matchstr(substitute(getline(v:foldstart),'\|.*','',''),'^.*/').'\ ['.(v:foldend-v:foldstart+1).'\ lines]'
setlocal nomodifiable

highlight errorcolor guibg=red
syn match errorcolor "error:"

highlight warningcolor guibg=yellow
syn match errorcolor "warning:"

highlight pathcolor guifg=cyan
syn match pathcolor "^[^|]*"

"if foldclosedend(1) == line('$') || line("$") < 25
"  " When all matches come from a single file, do not close that single fold;
"  " the user probably is interested in the contents.  Likewise if few results.
"  setlocal foldlevel=1
"else
"setlocal foldlevel=99
"endif
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

fun! AutoAdjustQFWindow()
  try
      let l:prev = winnr()
      for winnr in range(1, winnr('$'))
          if getwinvar(winnr, '&syntax') == 'qf'
              exe winnr . "wincmd w"
              call AdjustWindowHeight(1, 10)
              normal gg
              normal G
              exe l:prev . "wincmd w"
              normal :cfirst<cr>
              return 0
          endif
      endfor
      return 0
  catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun
