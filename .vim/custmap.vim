" Custom map
nnoremap q: :q
nnoremap Q <nop>
nnoremap <S-Enter> O<Esc>
nnoremap x "_x
vnoremap x "_d
noremap , :
noremap! jj <esc>
noremap! kk <esc>
vnoremap // y/<C-R>"<CR>

noremap <leader>a :set scb<cr>
noremap <leader>A :set scb!<cr>
noremap <leader>b :FufBuffer<cr>
noremap <leader>c :ccl<cr>
"noremap <leader>c <esc>:cscope c <C-r><C-w>
noremap <leader>C lc^
noremap <leader>d "_d
noremap <leader>e :e<space>./
"noremap <leader>wh<leader>e :let @e=expand('%:p:h')<cr><c-w>h:e <c-r>e/<tab>
"noremap <leader>wl<leader>e :let @e=expand('%:p:h')<cr><c-w>l:e <c-r>e/<tab>
"noremap <leader>f :pta <C-r><C-w><cr>
noremap <leader>f <C-w>z
noremap <leader>g :vimgrep /<C-r><C-w>/j ./**/*.[ch]*<left><left><left><left><left><left><left><left><left><left>
noremap <leader>G :grep! "<C-r><C-w>" ./
noremap <leader>h :call File_flip()<cr>
noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>j :tj <C-r><C-w><cr>
"noremap <leader>wh<leader>j :let @j='<C-r><C-w>'<cr><C-w>h:tj <C-r>j<cr>
"noremap <leader>wh<leader>j :let @j='<C-r><C-w>'<cr><C-w>h:tj <C-r>j<cr>
noremap <leader>J <C-O>
noremap <leader>l :TagbarToggle<cr>
"noremap <leader>mk :mksession ~/mysession.vim
noremap <leader>n :Explore<cr>
noremap <leader>o o<esc> " Could use :m[ove] +1
noremap <leader>O O<esc>
noremap <leader>p "_dP
noremap <leader>q :q<cr>
noremap <leader>r /\<<C-r><C-w>\><cr>:%s//
noremap <leader>s :SemanticHighlightToggle<cr>
vnoremap <leader>s "sy/<C-R>"<cr>:%s//<C-R>"/g<left><left>
noremap <leader>S /\<<C-r><C-w>\><cr>N
noremap <leader>t :vsp<cr>
noremap <leader>T :sp<cr>
noremap <leader>u :GundoToggle<cr>
noremap <leader>v <C-v>
"noremap <leader>w :up<cr>
noremap <leader>w <C-w>o:vsp<cr>
noremap <leader>ww <C-w>w
noremap <leader>x :bp\|bd #<cr>
noremap <leader>X :bp\|bd! #<cr>
noremap <leader>y "+y
noremap <leader>Z zO
noremap <leader>z zf

vnoremap <leader>=, :Tab /,\zs/l1r0<cr>gv=
vnoremap <leader>== :Tab /=<cr>gv=
vnoremap <leader>=<space> :Tab /\s\zs/l1r0<cr>gv=
vnoremap <leader>=; :Tabularize /\S\+;$/l1<cr>gv=

map <leader>m V<enter><c-e>
noremap <leader>M :MSClear<cr>
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
if use_arrow
  nnoremap <silent> <M-Right> <c-w>l
  nnoremap <silent> <M-Left> <c-w>h
  nnoremap <silent> <M-Up> <c-w>k
  nnoremap <silent> <M-Down> <c-w>j
endif

nnoremap <silent> <M-h> <c-w>h
nnoremap <silent> <M-l> <c-w>l
nnoremap <silent> <M-k> <c-w>k
nnoremap <silent> <M-j> <c-w>j
nnoremap <silent> <M-L> <c-w><
nnoremap <silent> <M-H> <c-w>>
nnoremap <silent> <M-K> <c-w>+
nnoremap <silent> <M-J> <c-w>-

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

nnoremap <silent> + <c-w>>
nnoremap <silent> - <c-w><

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
noremap <F4> :lcd! `pwd`/ \|make! -j<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Tab><Tab>
nnoremap <F5> :up<cr>:lcd!<Up><cr>:redr<cr>
inoremap <F5> <esc>:up<cr>:lcd!<Up><cr>:redr<cr>

"fun! NextTagOrError()
"    try
"    for nr in range(1, winnr('$'))
"        if getwinvar(nr, "&pvw") == 1
"            " found a preview
"            :tnext
"            return 0
"        endif  
"    endfor
"    :cn
"    catch /.*/
"      echohl WarningMsg | echon v:exception | echohl None
"    endtry
"endfun
"fun! PrevTagOrError()
"  try
"    for nr in range(1, winnr('$'))
"        if getwinvar(nr, "&pvw") == 1
"            " found a preview
"            :tprev
"            return 0
"        endif  
"    endfor
"    :cp
"  catch /.*/
"      echohl WarningMsg | echon v:exception | echohl None
"  endtry
"endfun
"noremap <F6> :call PrevTagOrError()<cr>
"noremap <F7> :call NextTagOrError()<cr>
noremap <F6> :cp<cr>
noremap <F7> :cn<cr>
noremap <F8> :cc<cr>

function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  endif
endfunction
noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc>:call ToggleSpell()<cr>
