" .Vimrc from Thomas Legris 28/06/2014
" Useful regex stuff:
" %s/\<word\>\C/new/g -> \< match begin \> match end \C case sensistiveness

" Script Setting
let use_arrow=0
let use_gui=0
let username="Thomas Legris"

set nocompatible

"  If you need infrmation on parameters, use :h param
if has("gui_running")
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

set vb " visual bell
syntax on "enable
set background=dark
colorscheme myslate

set ruler "Show cursor position, line, col"

" Max text width, 0 to disable it
set textwidth=0

" Wrappe à 72 caractères avec la touche '@#'
"map @# gwap
" Wrappe et justifie à 72 caractères avec la touche '@'
"map @ {v}! par 72j

"set columns=80
set history=50 " History entries max number
" ~/.viminfo's Options
set viminfo='20,\"50
set backspace=2 "Activate backspace
set whichwrap=<,>,[,] " Ok let's use arrow to naviguate
set scrolloff=1 " Keep one line after/before the cursor
set showcmd " Show cmd on status bar
set showmatch " Show paried symbols
set nostartofline
set wildmode=list:full:longest
set autoindent
set smartindent
set cino+=(0,+0 "C file option
set autoread
set clipboard=unnamed "^=

" xterm-debian est un terminal couleur
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
  au BufReadPre * setlocal foldmethod=marker
  au BufWinEnter * if &fdm == 'marker' | setlocal foldmethod=manual | endif
augroup END

set foldlevel=99
set foldnestmax=0

set incsearch " Search as we type
set hlsearch "Highlight

" Line number
"set number

set mouse=a

filetype on
filetype plugin on
set ruler " Relative cursor position
set is
set cul " Highlight current line

function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  endif
endfunction

noremap <F10> :call ToggleSpell()<cr>
inoremap <F10> <Esc> :call ToggleSpell()<cr>

" French and English spelling
au BufNewFile,BufRead *.tex setlocal spell spelllang=en,fr

set nospell

" Make options
set makeprg=make
noremap <F5> :make -j -C <Up>
noremap <F6> :cp<cr>
noremap <F7> :cn<cr>

" Ced: let this be the default CTAGS file location
"map tags :!exctags -R --c++-kinds=+p --fields=+iaS --extra=+q . <CR>
"set tags+=./tags
"
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
set tabstop=2
set shiftwidth=2

" Allow real tab in leader mapping
set wildcharm=<tab>
set timeoutlen=1000

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

noremap , :
noremap! jj <esc>


" Explorer options
""""""""""""""""""
let g:netrw_liststyle=3
"set winfixwidth

" Ced: for auto-completion popup menu
highlight Pmenu    guifg=black  guibg=grey
highlight PmenuSel guifg=grey guibg=black gui=bold

" Thanks to Pablo !
set completeopt+=longest 

"To close automatically the preview window:
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set laststatus=2 "status bar
" Let us use arline instead
"set statusline=%<%f%h%m%r:\ %{tagbar#currenttag('%s','')}%=%l,%c\ %P "status' bar content
let g:airline_theme='wombat'
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
let g:semanticColors = { 0x00: '#72d572', 0x01: '#c5e1a5', 0x02: '#e6ee9c', 0x03: '#fff59d', 0x04: '#ffe082', 0x05: '#ffcc80', 0x06: '#ffab91', 0x07: '#bcaaa4', 0x08: '#b0bec5', 0x09: '#ffa726', 0x0a: '#ff8a65', 0x0b: '#f9bdbb', 0x0c: '#f9bdbb', 0x0d: '#f8bbd0', 0x0e: '#e1bee7', 0x0f: '#d1c4e9', 0x10: '#ffe0b2', 0x11: '#c5cae9', 0x12: '#d0d9ff', 0x13: '#b3e5fc', 0x14: '#b2ebf2', 0x15: '#b2dfdb', 0x16: '#a3e9a4', 0x17: '#dcedc8' , 0x18: '#f0f4c3', 0x19: '#ffb74d' }

" Backup part
set nobackup
"set backupdir=~/.vim/vimfiles/backup

" Swap files
set swapfile
set directory=~/.vim/vimfiles/swap

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
