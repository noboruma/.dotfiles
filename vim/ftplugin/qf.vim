"setlocal foldlevel=99
setlocal foldlevel=0
setlocal foldmethod=expr
setlocal foldexpr=matchstr(getline(v:lnum),'^[^\|]\\+')==#matchstr(getline(v:lnum+1),'^[^\|]\\+')?1:'<1'
setlocal foldtext=matchstr(substitute(getline(v:foldstart),'\|.*','',''),'^.*').'\ ['.(v:foldend-v:foldstart+1).'\ lines]'
setlocal nomodifiable
setlocal wrap

setlocal synmaxcol=0

if foldclosedend(1) == line('$') || line("$") < 25
  " When all matches come from a single file, do not close that single fold;
  " the user probably is interested in the contents.  Likewise if few results.
  setlocal foldlevel=1
else
  setlocal foldlevel=0
endif

" Need to happen only once
if !exists('g:ansiesc')
    "call AnsiEsc#AnsiEsc(0)
    let g:ansiesc=1
endif

syn match errorcolor "[eE]rror"
highlight errorcolor ctermbg=red guibg=red

syn match warningcolor "[wW]arning"
highlight warningcolor ctermbg=yellow guibg=yellow

syn match pathcolor "\v^[^|]+"
highlight pathcolor ctermfg=cyan guifg=cyan

syn match singlequote "\v'[^']*'"
highlight singlequote ctermfg=cyan guifg=cyan

syn match doublequote "\v\"[^\"]*\""
highlight doublequote ctermfg=blue guifg=blue

syn match numbers "\v[0-9]+"
highlight numbers ctermfg=brown guifg=brown

syn match linecol "\v\|[0-9]+ col [0-9]+\|"
highlight linecol ctermfg=green guifg=green

function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

let g:asyncrun_gotoend = 0

fun! AutoAdjustQFWindow()
  try
      let l:prev = winnr()
      for winnr in range(1, winnr('$'))
          if getwinvar(winnr, '&syntax') == 'qf'
              exe winnr . "wincmd w"
              call AdjustWindowHeight(5, 10)
              if g:asyncrun_gotoend == 1
                  normal G
              endif
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
