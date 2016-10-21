" .Vimrc from Thomas Legris 28/06/2014
" Useful regex stuff:
" %s/\<word\>\C/new/g -> \< match begin \> match end \C case sensistiveness
set shell=zsh
" Script Setting
let use_arrow=0
let use_gui=0
let username="Thomas Legris"

set nocompatible

"  If you need infrmation on parameters, use :h param
if has("gui_running")
  set shell=bash " better support
  " Gvim specific
  set lines=999
  set columns=999
  set guioptions=
  if use_gui
    set guioptions+=m  "menu bar
    set guioptions+=T  "toolbar
    set guioptions+=r  "scrollbar
  endif
endif

set path+=../**

" Start to be a good vimmer
if !use_arrow
  inoremap  <Left>   <NOP>
  inoremap  <Right>  <NOP>
  nnoremap  <Up>     <NOP>
  nnoremap  <Down>   <NOP>
  nnoremap  <Left>   <NOP>
  nnoremap  <Right>  <NOP>
endif

set guifont=Monospace\ 9

set vb                         " visual bell
syntax on                      " enable
set background=dark
colorscheme myslate

set ruler                      " Show cursor position, line, col
set textwidth=0                " Max text width, 0 to disable it
" map @# gwap                  " Wrappe à 72 caractères avec la touche '@#'
" map @ {v}! par 72j           " Wrappe et justifie à 72 caractères avec la touche '@'
" set columns=80
set history=50                 " History entries max number
set viminfo='20,\"50           " ~/.viminfo's Options
set backspace=2                " Activate backspace
set whichwrap=<,>,[,]          " Ok let's use arrow to naviguate
set scrolloff=1                " Keep one line after/before the cursor
set showcmd                    " Show cmd on status bar
set showmatch                  " Show paried symbols
set nostartofline
set wildmode=list:full:longest
set autoindent
set smartindent
set cino+=j1,(0,+0                " C file option
set autoread
set clipboard=unnamed          " ^=
" Prevent RO file editing: use 'set modifiable' manually if needed
autocmd BufRead * let &modifiable = !&readonly

" xterm-debian is a color terminal 
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif
if &term =~ "xterm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Show space and tab as blue
"set list
"set listchars=tab:>-,trail:-

"set ignorecase
" as ignore case but not if one Capital letter
set smartcase

" Folding
" Trigger manual after indent method
augroup vimrc
  au BufReadPre * setlocal foldmethod=expr
  au BufReadPost * normal zM
  au BufWinEnter * if &fdm == 'expr' | setlocal foldmethod=manual | endif
augroup END

set foldlevel=99
set foldnestmax=0

set incsearch      " Search as we type
set hlsearch       " Highlight

                   " Line number
                   " set number

set mouse=a

filetype on
filetype plugin on
set ruler          " Relative cursor position
set is
set cul            " Highlight current line

function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  endif
endfunction

noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc> :call ToggleSpell()<cr>

set nospell

" Make options
let &makeprg='mw gmake'

function! CaptureExtOutput(cmd)
  let out = system(a:cmd)
  ene
  silent put=out
  set nomodified
endfunction
command! -nargs=+ -complete=command CaptureExtOutput call CaptureExtOutput(<q-args>)

norem <F1> :CaptureExtOutput <Up>
"noremap <F4> :make! -j -C <Up>
"nnoremap <F5> :up<cr>:make! -j -C <Up><cr>:redr<cr>
"inoremap <F5> <esc>:up<cr>:make! -j -C <Up><cr>:redr<cr>
noremap <F4> :lcd! `pwd`/ \|make! -j<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <F5> :up<cr>:lcd!<Up><cr>:redr<cr>
inoremap <F5> <esc>:up<cr>:lcd!<Up><cr>:redr<cr>

fun! NextTagOrError()
    try
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            " found a preview
            :tnext
            return 0
        endif  
    endfor
    :cn
    catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
    endtry
endfun
fun! PrevTagOrError()
  try
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            " found a preview
            :tprev
            return 0
        endif  
    endfor
    :cp
  catch /.*/
      echohl WarningMsg | echon v:exception | echohl None
  endtry
endfun
"noremap <F6> :call PrevTagOrError()<cr>
"noremap <F7> :call NextTagOrError()<cr>
noremap <F6> :call :cp
noremap <F7> :call :cn
noremap <F8> :cc<cr>

" Ced: let this be the default CTAGS file location
"map tags :!exctags -R --c++-kinds=+p --fields=+iaS --extra=+q . <CR>
"set tags+=./tags

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
augroup vimrc
  autocmd QuickFixCmdPost [^l]* nested botright cwindow " Botright to open widely
  autocmd QuickFixCmdPost    l* nested botright lwindow
augroup END

" Handle space and tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Allow real tab in leader mapping
set wildcharm=<tab>
set timeoutlen=500

" Path setting => No need as indexer plugin take care of that
"let s:default_path = escape(&path, '\ ') " store default value of 'path'
"
"" Always add the current file's directory to the path and tags list if not
"" already there. Add it to the beginning to speed up searches.
"autocmd BufRead *
"      \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
"      \ exec "set path-=".s:tempPath |
"      \ exec "set path-=".s:default_path |
"      \ exec "set path^=".s:tempPath |
"      \ exec "set path^=".s:default_path

let mapleader=" "
source ~/.vim/custmap.vim

" Explorer options
""""""""""""""""""
let g:netrw_liststyle=3
"set winfixwidth

" Ced: for auto-completion popup menu
highlight Pmenu    guifg=black  guibg=grey
highlight PmenuSel guifg=grey guibg=black gui=bold
"Thomas: let's change it for term as well
highlight Pmenu    ctermbg=grey gui=bold
highlight PmenuSel ctermbg=cyan gui=bold

" Thanks to Pablo !
set completeopt=menu,menuone,longest,preview

"To close automatically the preview window:
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set laststatus=2 "status bar
" Let us use arline instead
"set statusline=%<%f%h%m%r:\ %{tagbar#currenttag('%s','')}%=%l,%c\ %P "status' bar content
let g:airline_theme='light'
let g:airline_detect_whitespace=0
  let g:airline_mode_map = {
      \ '__' : '',
      \ 'n'  : '',
      \ 'i'  : '',
      \ 'R'  : '',
      \ 'c'  : '',
      \ 'v'  : '',
      \ 'V'  : '',
      \ '' : '',
      \ 's'  : '',
      \ 'S'  : '',
      \ '' : '',
      \ }


set showbreak=↪
set wrap
set cpo+=n

set autochdir

" Tagbar options
""""""""""""""""""
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

hi CursosLine gui=underline

"Remove TagHighlight & Easy translate
let g:loaded_TagHighlight = 1
if ! exists('g:TagHighlightSettings')
  let g:TagHighlightSettings = {}
endif

let g:rainbow_active = 1
let g:rainbow_conf = {
   \ 'operators' : '_,\|=\|+\|\*\|-\|\.\|;\||\|&\|?\|:\|<\|>\|%\|/[^/*]_',
   \ 'separately': {
   \   'cpp': {
   \     'parentheses': [
   \       'start=/(/ end=/)/ fold',
   \       'start=/\[/ end=/\]/ fold',
   \       'start=/{/ end=/}/ fold',
   \       'start=/\(\(\<operator\>\)\@<!<\)\&[a-zA-Z0-9_]\@<=<\ze[^<]/ end=/>/'] } } }

" Uncomment the following to have Vim jump to the last position when
" reopening a file
augroup vimrc
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Keep buffers hidden instead of closing it
set hidden 

" More natural split opening
set splitbelow 
set splitright

"Timestamp
let g:AutoAdapt_FilePattern = ''
let g:AutoAdapt_FirstLines = 10
let g:AutoAdapt_LastLines = 0
let g:AutoAdapt_Rules = [
\   {
\       'name': 'Copyright notice',
\       'patternexpr': '''\c\<Copyright:\?\%(\s\+\%((C)\|&copy;\|\%xa9\)\)\?\s\+\zs\(\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\%(\ze\k\@![^-]\|\(-\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\>\)''',
\       'replacement': '\=submatch(1) . "-" . strftime("%Y")',
\	    'range': '1,10'
\   },
\   {
\       'name': 'Last Change notice',
\       'pattern': '\v\C%(<Last %([uU]pdate?|[Mm]odified)\s+)@<=.*$',
\       'replacement': '\=strftime("%a %b %d %H:%M:%S %Y '.username.'")',
\	    'range': '1,10'
\   }
\]

" Language Tools
let g:languagetool_jar='$HOME/usr/bin/languagetool-commandline.jar'

" Semantic Highlight
let g:semanticGUIColors = ['#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]

" Backup part
set nobackup
"set backupdir=~/.vim/vimfiles/backup

" Swap files
set noswapfile
"set directory=~/.vim/vimfiles/swap

" Undo files
if (exists("&undodir"))
    set undofile
    set undodir=~/.vim/vimfiles/undo
    "let &undodir=&directory
    set undolevels=255
    set undoreload=255
endif

" start up message short
set shortmess+=I 

" Colorizer
let g:colorizer_nomap = 1
let g:colorizer_startup = 0

let g:syntastic_tex_checkers = ['chktex']

let g:ConqueGdb_Leader = '\'
let g:ConqueTerm_CloseOnEnd = 1

set modeline

let g:atp_Compiler = "python"

" session
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

" word-motion setup
" w/e/b/W replaced by default

""""""""""""" Standard cscope/vim boilerplate

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag

" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order.
set csto=0

" add any cscope database in current directory
if filereadable("cscope.out")
    cs add cscope.out  
" else add the database pointed to by environment variable 
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

" show msg when any other cscope db added
set cscopeverbose 

" No preview mode in fuzzy finder
let g:fuf_previewHeight=0

let g:indexer_disableCtagsWarning=1
