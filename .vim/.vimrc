" .Vimrc from Thomas Legris 28/06/2014
" Useful regex stuff:
" %s/\<word\>\C/new/g -> \< match begin \> match end \C case sensistiveness
" copy command output:
" redir @* | cmd | redir END
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
  set scrolloff=25 " Keep some lines after/before the cursor
else
  set scrolloff=8 " Usually smaller screen on terminal
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
set cmdheight=1

set vb                         " visual bell
syntax on                      " enable
set background=dark
colorscheme myslate

set ruler                      " Show cursor position, line, col
set textwidth=0                " Max text width, 0 to disable it
" map @# gwap                  " Wrappe à 72 caractères avec la touche '@#'
" map @ {v}! par 72j           " Wrappe et justifie à 72 caractères avec la touche '@'
"set columns=80
set history=50                 " History entries max number
set viminfo='20,\"50           " ~/.viminfo's Options
set backspace=2                " Activate backspace
set whichwrap=<,>,[,]          " Ok let's use arrow to naviguate
set showcmd                    " Show cmd on status bar
set showmatch                  " Show paried symbols
set startofline
set wildmode=list:full:longest
set autoindent
set smartindent
set cino+=j1,(0,+0             " C file option
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
  au BufWinEnter * if &fdm == 'expr' | setlocal foldmethod=manual | normal zM | endif
augroup END

set foldlevel=99
set foldnestmax=0

set incsearch      " Search as we type
set hlsearch       " Highlight

                   " Line number
                   " set number

set mouse=a

filetype off

" Syntastic
"let &runtimepath.=',~/.vim/bundle/syntastic'
"
"let g:syntastic_cpp_checkers = ["cppcheck", "clang_tidy"]
"let g:syntastic_cpp_cppcheck_args = '--std=c++11'
"let g:syntastic_cpp_compiler = 'g++'
"let g:syntastic_cpp_compiler_options = "-Wall -Wpedantic -Wextra -std=c++1y"
"let g:syntastic_cpp_include_dirs = ['../export' ]
"let g:syntastic_cpp_check_header = 0
"let g:syntastic_cpp_remove_include_errors = 1
"let g:syntastic_cpp_config_file = '.syntastic_cpp_config'
"let g:syntastic_clang_tidy_config_file = '.syntastic_clang_tidy_config'
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_aggregate_errors = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"
"let g:syntastic_debug = 0
"!Syntastic

" Ale
let &runtimepath.=',~/.vim/bundle/ale'
let g:ale_linters = {
\   'cpp': ['g++', 'cppcheck', 'clangtidy'],
\}
let g:ale_cpp_gcc_options = '$(cat ~/.compiler_options)' "Options can be easily retrieved using 'bear' (github)
let g:ale_cpp_clangtidy_options = '$(cat ~/.compiler_options)'
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '%s [%linter%|%severity%]'
"!Ale

" airline plugin
set laststatus=2 "status bar
let &runtimepath.=',~/.vim/bundle/airline'
let &runtimepath.=',~/.vim/bundle/airline-themes'
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
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
"!Airline
"Rainbow plugin
let &runtimepath.=',~/.vim/bundle/rainbow'
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
"!Rainbow
"Slime plugin
let &runtimepath.=',~/.vim/bundle/slime'
let g:slime_target = "tmux"
"!Slime
" Tagbar options
""""""""""""""""""
let &runtimepath.=',~/.vim/bundle/tagbar'
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
" !Tagbar

" AsyncRun
let &runtimepath.=',~/.vim/bundle/asyncrun'
" !AsyncRun

filetype on
filetype plugin on
set ruler          " Relative cursor position
set is             " inc search
set cul            " Highlight current line

set spelllang=en
set nospell
" c-x c-k feature:
set dictionary+=/usr/share/dict/words
" Language Tools
"let g:languagetool_jar='$HOME/usr/bin/languagetool-commandline.jar'

" Make options
let &makeprg='make'
"
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
  "autocmd QuickFixCmdPost [^l]* nested botright cwindow " Botright to open widely
  "autocmd QuickFixCmdPost    l* nested botright lwindow
  "autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)
  " The pre is to counter the copen from leaders aliases
  autocmd User AsyncRunPre setl foldlevelstart=99 | wincmd k
  autocmd User AsyncRunStop botright copen | normal zM
augroup END

" Handle space and tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Allow real tab in leader mapping
set wildcharm=<tab>
set timeoutlen=500

let mapleader=" "
source ~/.vim/custmap.vim

" Explorer options
""""""""""""""""""
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=delete
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

set showbreak=↪
set wrap
set cpo+=n

set autochdir

hi CursosLine gui=underline

" Jump to the last position when reopening a file
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
    set undolevels=1024
    set undoreload=1024
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
set ssop+=localoptions

" word-motion setup
" w/e/b/W replaced by default

""""""""""""" Standard cscope/vim boilerplate
" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
"set cscopetag
"" check cscope for definition of a symbol before checking ctags: set to 1
"" if you want the reverse search order.
"set csto=0
"" add any cscope database in current directory
"if filereadable("cscope.out")
"    cs add cscope.out  
"" else add the database pointed to by environment variable 
"elseif $CSCOPE_DB != ""
"    cs add $CSCOPE_DB
"endif
"" show msg when any other cscope db added
"set cscopeverbose 

" No preview mode in fuzzy finder
let g:fuf_previewHeight=0

let g:indexer_disableCtagsWarning=1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

