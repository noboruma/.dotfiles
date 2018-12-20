" Custom map
nnoremap Q <nop>
nnoremap x "_x
vnoremap x "_d
nnoremap X "_X
nnoremap , :
nnoremap ,, <nop>
inoremap ,, <esc>
inoremap jj <esc>j
inoremap kk <esc>k
inoremap JJ <esc>J
inoremap KK <esc>K
nnoremap // /\<<C-r><C-w>\><cr>
vnoremap // "sy/<C-R>"<cr>

function! IsLeftMostWindow()
    let curNr = winnr()
    wincmd h
    if winnr() == curNr
        return 1
    endif
    wincmd p " Move back.
    return 0
endfunction

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>
cnoremap <C-k> <C-w><C-w>

"noremap <leader>a :set scb<cr> " just use vimdiff or Linediff
"noremap <leader>A :set scb!<cr>
"noremap <leader>b :FufBuffer<cr>
noremap <leader>b :<c-u>Buffers <cr>
noremap <leader>c :<c-u>ccl\|lcl\|pcl<cr>
noremap <leader>C :AsyncStop<cr>
noremap <leader>d "_d
noremap <leader>e :silent<space>e<space>`pwd`<tab>
noremap <leader>ff :<c-u>Files<space>`pwd`<tab>
if executable('cquery')
   nnoremap <leader>fa :call AutoAdjustQFWindow()<cr>
   nnoremap <leader>fd :LspDefinition<CR>
   nnoremap <leader>fc :LspCqueryCallers<cr>
   nnoremap <leader>fv :LspCqueryVars<cr>
   nnoremap <leader>fh :LspHover<CR>
   nnoremap <leader>ft :call LspFunctionType()<cr>
else
    noremap <leader>f :botright pta <C-r><C-w><cr>
    noremap <leader>F "sy:botright pta /<C-R>"
    vnoremap <leader>f "sy:botright pta /<C-R>"<cr>
    vnoremap <leader>F "sy:botright pta /<C-R>"
endif
"Add --cpp or --type:
noremap <leader>g :AsyncRun -program=grep "<C-r><C-w>" `pwd`<tab>
vnoremap <leader>g "sy:AsyncRun -program=grep "<C-R>"" `pwd`<tab>
nnoremap <leader>G :lcd<space>`pwd`<tab><space>\|<space>Ag<left><left><left><left><left><tab>
vnoremap <leader>G "sy:lcd<space>`pwd`<tab><space>\|<space>Ag<space><C-R>"<C-f>F\|<left><C-c><tab>
noremap <leader>h :<c-u>call File_flip()<cr>zz
nnoremap <leader>H :<c-u>History<cr>
"noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>j :<c-u>tj <C-r><C-w><cr>
noremap <leader>J :<c-u>tj /<C-r><C-w><C-b><right><right><right><right>
vnoremap <leader>j "sy:tj /<C-R>"<cr>
vnoremap <leader>J "sy:tj /<C-R>"
" Use surfraw to search on the web
noremap <leader>l :<c-u>let g:tagbar_left=IsLeftMostWindow()<cr>:TagbarOpen j<cr>
"noremap <leader>mk :mksession ~/mysession.vim
nnoremap <leader>m :Marks<cr>
noremap <leader>mm <esc>:SlimeSend1 cppman <C-r><C-w>
noremap <leader>o <c-w>w
noremap <leader>O <esc>:only<cr>:vsp<cr>
noremap <leader>p "_dP
noremap <leader>q :<c-u>q<cr>
noremap <leader>r /\<<C-r><C-w>\><cr>:%s//<C-r><C-w>/g<left><left>
vnoremap <leader>r "sy/<C-R>"<cr>:%s//<C-R>"/g<left><left>
noremap <leader>s vi
noremap <leader>s, vi,
noremap <leader>S :<c-u>SemanticHighlightToggle<cr>
nnoremap <leader>t :<c-u>vsp<cr>
nnoremap <leader>_ :<c-u>sp<cr>
noremap <leader>u :<c-u>UndotreeToggle<cr>:UndotreeFocus<cr>
noremap <leader>v <C-v>
noremap <leader>w :<c-u>up<cr>
noremap <leader>x :<c-u>bp\|bd #<cr>
noremap <leader>X :<c-u>bp\|bd! #<cr>
noremap <leader>y "+y
noremap <leader>z zR
noremap <leader>Z zM

vnoremap <leader>=, :Tab /,\zs/l1r0<cr>gv=
vnoremap <leader>== :Tab /=<cr>gv=
vnoremap <leader>=<space> :Tab /\s\zs/l1r0<cr>gv=
vnoremap <leader>=; :Tabularize /\S\+;$/l1<cr>gv=
vnoremap <leader>=( :Tabularize /\S\+($/l1<cr>gv=

noremap <leader>\ :<c-u>ConqueGdb<cr>
noremap <leader>/ :<c-u>nohlsearch<cr>
noremap <leader>1 "1 ; Register
noremap <leader>2 "2 ; Register
noremap <leader>3 "3 ; Register
noremap <leader><cr> a<cr><esc>
noremap <leader>> x<esc>wP
noremap <leader>< x<esc>bep

noremap <leader><bs> <C-O>
" <leader><tab> <C-I>

" Custom hard remap
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

fun LspFunctionType()
    let l:pos=getpos('.')
    normal f)%h
    execute ":LspHover<cr>"
    call cursor(l:pos[1], l:pos[2])
endfun
inoremap <c-f> <c-x><c-f>
inoremap <c-l> <c-x><c-l>
inoremap <c-k> <c-o>:call LspFunctionType()<cr>
nnoremap <silent> <c-k> <Esc>:Cppman <cword><CR>
vnoremap <silent> <c-k> "sy:Cppman <C-R>"<CR>

" Adding silent helps not asking anything in the command
"nnoremap <silent> <C-h> <c-w><
"nnoremap <silent> <C-l> <c-w>>
"nnoremap <silent> <C-k> <c-w>+
"nnoremap <silent> <C-j> <c-w>-

"ALT: M-xxx

" scroll remap
nnoremap <c-j> J
"nnoremap <c-k> K
nnoremap J <c-e>
nnoremap K <c-y>

" Simulate <down> after CTRL-N
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
"inoremap <expr> <tab>      pumvisible() ? "\<C-n>" : "\<C-r>=\<SID>close_paren()\<CR>\<c-r>=Smart_TabComplete()\<CR>"
"inoremap <expr> <s-tab>    pumvisible() ? "\<C-p>" : "\<s-tab>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CaptureExtOutputInNewBuffer(cmd)
  let out = system(a:cmd)
  ene
  silent put=out
  set nomodified
endfunction
command! -nargs=+ -complete=command CaptureExtOutputInNewBuffer call CaptureExtOutputInNewBuffer(<q-args>)

noremap <F1>  :<c-u>!git add %<cr>
noremap <F2>  :<c-u>set modifiable<cr>:set noro<cr>

let g:cppmanprovider = 0
fun IterateThroughProviders()
    if has("gui_running")
        let l:tmux_command="new-window"
        let l:sr_command='sr'
        let l:focus="-d"
        let l:silent="silent"
    else
        let l:tmux_command="split-window"
        let l:sr_command='sr -browser=w3m'
        let l:focus=""
        let l:silent=""
    endif

    if (g:cppmanprovider == 0)
        let g:cppmanprovider = 1
        command! -nargs=+ Cppman silent exe "silent !tmux ".l:tmux_command." ".l:focus." '".l:sr_command." google \"" . expand(<q-args>) . "\"'"
        echom "switch to google"
    elseif (g:cppmanprovider == 1)
        let g:cppmanprovider = 2
        command! -nargs=+ Cppman silent exe "silent !tmux ".l:tmux_command." ".l:focus."'".l:sr_command." duckduckgo \"" . expand(<q-args>) . "\"'"
        echom "switch to duckduckgo"
    elseif (g:cppmanprovider == 2)
        let g:cppmanprovider = 3
        command! -nargs=+ Cppman silent exe l:silent."!tmux ".l:tmux_command." 'cppman " . expand(<q-args>) . "'"
        echom "switch to cppman"
    elseif (g:cppmanprovider == 3)
        let g:cppmanprovider = 0
        command! -nargs=+ Cppman silent exe l:silent."!tmux ".l:tmux_command." 'man " . expand(<q-args>) . "'"
        echom "switch to man"
    endif
endfun
if has("gui_running")
    command! -nargs=+ Cppman exe "silent !tmux new-window -d 'sr duckduckgo \"" . expand(<q-args>) . "\"'"
else
    command! -nargs=+ Cppman exe "silent !tmux split-window 'sr -browser=w3m duckduckgo \"" . expand(<q-args>) . "\"'"
endif

noremap <F3> :<c-u>call IterateThroughProviders()<cr>

" Need to manually call copen first so that directories are correctly set
" (issue with asyncrun?)


noremap <expr> <F4> exists('debug') ? ":<c-u>AsyncRun -program=make @ -j4 DEBUG=1 -C `pwd`/<tab><tab>" : ":<c-u>AsyncRun -program=make @ -j4 -C `pwd`/<tab><tab>"

nnoremap <F5> :<c-u>ccl<cr>:up<cr>:AsyncRun -program=make<Up><cr>
inoremap <F5> <esc>:<c-u>ccl<cr>:up<cr>:AsyncRun -program=make<Up><cr>

noremap <expr> <F9> exists('debug') ?  ":<c-u>unlet debug<cr>" : ":<c-u>let debug=1<cr>"

fun IsQFOrLocOrTagOpen()
    silent exec 'redir @a | ls | redir END'
    if match(@a,'\[Location List\]') >= 0
        return 2
    elseif match(@a,'\[Quickfix List\]') >= 0
        return 1
    else
        return 3
    endif
endfun

fun NextWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cn
            return 0
        elseif l:res == 2
            :ln
        elseif l:res == 3
            ":ptn
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun
fun PrevWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            :cp
            return 0
        elseif l:res == 2
            :lp
        elseif l:res == 3
            ":ptp
        endif
        return 0
    catch /.*/
        echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun
fun CurrWinOrQFError()
    try
        let l:res = IsQFOrLocOrTagOpen()
        if l:res == 1
            if exists('g:jumpfirst') && g:jumpfirst == 1
                :cfirst
                :cn
                let g:jumpfirst=0
            else
                :cc
            endif
            :cp
            return 0
        elseif l:res == 2
            :ll
        elseif l:res == 3
            ":ptr
        endif
        return 0
    catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun

noremap <F6> :<c-u>call PrevWinOrQFError()<cr>
noremap <F7> :<c-u>call NextWinOrQFError()<cr>
noremap <F8> :<c-u>call CurrWinOrQFError()<cr>

function ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  endif
endfunction
noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc>:call ToggleSpell()<cr>

noremap <F11> <esc>:up<cr>:!!<cr>

function s:close_paren() abort
    augroup close_paren
        " use 'fire once' auto command tech
        autocmd!
        autocmd CompleteDone <buffer> silent! if v:completed_item.word =~# '($'
                    \|      call feedkeys(")\<Left>", 'in')
                    \| endif
                    \| autocmd! close_paren
                    \| augroup! close_paren
    augroup END
    return ''
endfunction

"function Smart_TabComplete()
"    let line = getline('.')                         " current line
"
"    let substr = strpart(line, -1, col('.'))      " from the start of the current
"    " line to one character right
"    " of the cursor
"    let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
"    if (strlen(substr)==0)                          " nothing to match on empty string
"        return "\<tab>"
"    endif
"    let has_period = match(substr, '\.') != -1      " position of period, if any
"    let has_slash = match(substr, '\/') != -1       " position of slash, if any
"    let has_colon = match(substr, '::') != -1     " position of ::, if any
"    if (!has_period && !has_slash && !has_colon)
"        return "\<C-X>\<C-P>"                         " existing text matching
"    elseif ( has_slash )
"        return "\<C-X>\<C-F>"                         " file matching
"    else
"        call asyncomplete#force_refresh()
"        "return "\<tab>"                         " plugin matching
"    endif
"endfunction

if &diff
    noremap <F5> :<c-u>tabclose<cr>
    noremap <F6> :<c-u>tabprev<cr>
    noremap <F7> :<c-u>tabnext<cr>
endif
