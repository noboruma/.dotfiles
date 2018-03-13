" Custom map
nnoremap Q <nop>
nnoremap x "_x
vnoremap x "_d
nnoremap X "_X
noremap , :
noremap! jj <esc>
noremap! kk <esc>
vnoremap // y/<C-R>"<CR>``

function! IsLeftMostWindow()
    let curNr = winnr()
    wincmd h
    if winnr() == curNr
        return 1
    endif
    wincmd p " Move back.
    return 0
endfunction

noremap <leader>a :set scb<cr>
noremap <leader>A :set scb!<cr>
"noremap <leader>b :FufBuffer<cr>
noremap <leader>b :Unite -auto-resize -toggle buffer<cr><esc><esc>
noremap <leader>c :ccl\|lcl\|pcl<cr>
"noremap <leader>c <esc>:cscope c <C-r><C-w>
noremap <leader>C lc^
noremap <leader>d "_d
noremap <leader>e :e<space>`pwd`<tab>
noremap <leader>E :Explore<cr>
"noremap <leader>wh<leader>e :let @e=expand('%:p:h')<cr><c-w>h:e <c-r>e/<tab>
"noremap <leader>wl<leader>e :let @e=expand('%:p:h')<cr><c-w>l:e <c-r>e/<tab>
noremap <leader>f :botright pta <C-r><C-w><cr>
"noremap <leader>f <C-w>z
"noremap <leader>f f(l
"noremap <leader>F T(
"noremap <leader>fi :grep! --cpp "class(\w\\|\s\\|\n)+\w(\s\\|\n)*:(\s\\|\w\\|\n)*<C-r><C-w>(\s\\|\n)+" `pwd`<tab>
"noremap <leader>fc :grep! --cpp "<C-r><C-w>(\s\\|\n)*\((.\\|\n)*\);" `pwd`<tab>
"noremap <leader>f :cs find  <C-r><C-w><C-b><Right><Right><Right><Right><Right><Right><Right><Right><Tab>
"noremap <leader>g :vimgrep /<C-r><C-w>/j ./**/*.[ch]*<left><left><left><left><left><left><left><left><left><left>
noremap <leader>g :botright copen\|AsyncRun -program=grep "<C-r><C-w>" `pwd`<tab>
noremap <leader>gc :botright copen\|AsyncRun -program=grep --cpp "<C-r><C-w>" `pwd`<tab>
noremap <leader>gg :botright copen\|AsyncRun -program=grep "<C-r><C-w>" `pwd`<tab>
noremap <leader>h :call File_flip()<cr>zz
noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>j :tj <C-r><C-w><cr>
noremap <leader>J :tj /<C-r><C-w><C-b><right><right><right><right>
"noremap <leader>wh<leader>j :let @j='<C-r><C-w>'<cr><C-w>h:tj <C-r>j<cr>
"noremap <leader>wh<leader>j :let @j='<C-r><C-w>'<cr><C-w>h:tj <C-r>j<cr>
noremap <leader><bs> <C-O>
noremap <leader><leader><bs> <C-I>
noremap <leader>l :let g:tagbar_left=IsLeftMostWindow()<cr>:TagbarOpen j<cr>
noremap <leader>L :TagbarClose<cr>
"noremap <leader>mk :mksession ~/mysession.vim
noremap <leader>m <esc>:SlimeSend1 cppman <C-r><C-w>
nmap <leader>n via<esc>f,l
nmap <leader>N viao<esc>F,h
noremap <leader>o <c-w>w
noremap <leader>p "_dP
noremap <leader>q :q<cr>
noremap <leader>r /\<<C-r><C-w>\><cr>:%s//<C-r><C-w>/g<left><left>
noremap <leader>s /\<<C-r><C-w>\><cr>``zz
noremap <leader>S :SemanticHighlightToggle<cr>
vnoremap <leader>s "sy/<C-R>"<cr>:%s//<C-R>"/g<left><left>
noremap <leader>t :vsp<cr>
noremap <leader>T :sp<cr>
noremap <leader>u :GundoToggle<cr>
noremap <leader>v <C-v>
"noremap <leader>w :up<cr>
noremap <leader>w <C-w>o:vsp<cr>
noremap <leader>x :bp\|bd #<cr>
noremap <leader>X :bp\|bd! #<cr>
noremap <leader>y "+y

vnoremap <leader>=, :Tab /,\zs/l1r0<cr>gv=
vnoremap <leader>== :Tab /=<cr>gv=
vnoremap <leader>=<space> :Tab /\s\zs/l1r0<cr>gv=
vnoremap <leader>=; :Tabularize /\S\+;$/l1<cr>gv=

"map <leader>m V<enter><c-e>
"noremap <leader>M :MSClear<cr>
"noremap <C-m> :MSExecCmd

noremap <leader>\ :ConqueGdb<cr>
noremap <leader>/ :nohlsearch<cr>
noremap <leader>* /<c-r><c-w>/n<cr>
noremap <leader>1 "1 ; Register
noremap <leader>2 "2 ; Register
noremap <leader>3 "3 ; Register
noremap <leader><cr> a<cr><esc>
noremap <leader>; A;<esc>
noremap <leader>> x<esc>wP
noremap <leader>< x<esc>bep
vmap <leader>{ Sb=i{

" Custom hard remap
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

inoremap <c-f> <c-x><c-f>
inoremap <c-l> <c-x><c-l>

" Split naviguation
" silent help to not ask anything in the command
nnoremap <silent> <C-h> <c-w><
nnoremap <silent> <C-l> <c-w>>
nnoremap <silent> <C-k> <c-w>+
nnoremap <silent> <C-j> <c-w>-

"ALT: M-xxx

" Make omnicompletion easier (Context based autocompletion)
" For gui
inoremap <C-Space> <C-x><C-o>
" For terminal
inoremap <C-@> <C-Space>

" scroll remap
noremap <C-J> <C-E>
noremap <C-K> <C-Y>


" Simulate <down> after CTRL-N
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"nmap <kPlus> zo
"nmap <kMinus> zc
"nmap + zo
"nmap - zc

"function! CaptureExtOutput(cmd)
"  let out = system(a:cmd)
"  ene
"  silent put=out
"  set nomodified
"endfunction
"command! -nargs=+ -complete=command CaptureExtOutput call CaptureExtOutput(<q-args>)
"norem <F1> :CaptureExtOutput <Up>
"noremap <F4> :make! -j -C <Up>
"nnoremap <F5> :up<cr>:make! -j -C <Up><cr>:redr<cr>
"inoremap <F5> <esc>:up<cr>:make! -j -C <Up><cr>:redr<cr>
" Need to manually call copen first so that directories are correctly set
" (issue with asyncrun?)
noremap <F4>  :botright copen\|AsyncRun -program=make @ -j4 -C `pwd`/<tab><tab>
nnoremap <F5> :ccl<cr>:up<cr>:botright copen\|AsyncRun -program=make<Up><cr>
inoremap <F5> <esc>:ccl<cr>:up<cr>:botright copen\|AsyncRun -program=make<Up><cr>

fun! NextWinOrQFError()
  try
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            :cn
            return 0
        elseif getwinvar(winnr, "&pvw") == 1
            " found a preview
            :ptn
            return 0
        endif
    endfor
    :ln
    return 0
  catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun
fun! PrevWinOrQFError()
  try
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            :cp
            return 0
        elseif getwinvar(winnr, "&pvw") == 1
            " found a preview
            :ptp
            return 0
        endif
    endfor
    :lp
    return 0
  catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun
fun! CurrWinOrQFError()
  try
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            :cc
            return 0
        elseif getwinvar(winnr, "&pvw") == 1
            :ptr
            return 0
        endif
    endfor
    :ll
    return 0
  catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun
noremap <F1> <esc><c-=>
inoremap <F1> <esc><c-=>

noremap <F6> :call PrevWinOrQFError()<cr>
noremap <F7> :call NextWinOrQFError()<cr>
noremap <F8> :call CurrWinOrQFError()<cr>

function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  endif
endfunction
noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc>:call ToggleSpell()<cr>

noremap <F11> <esc>:up<cr>:!!<cr>

noremap <F1>  :!p4 edit %<cr>
noremap <F2>  :set modifiable<cr>:set noro<cr>
