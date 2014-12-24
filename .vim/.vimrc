" .Vimrc from Thomas Legris 28/06/2014

"  If you need infrmation on parameters, use :h param
" Maximize GVim on start
if has("gui_running")
  " Gvim specific
endif

" Start to be a good vimmer
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
nnoremap  <Up>     <NOP>
"<C-Y>
nnoremap  <Down>   <NOP>
"<C-E>
nnoremap  <Left>   <NOP>
nnoremap  <Right>  <NOP>
 
set guifont=Monospace\ 11

set guioptions=
"set guioptions+=m  "menu bar
"set guioptions+=T  "toolbar
"set guioptions+=r  "scrollbar

set vb " visual bell
syntax on "enable
set background=dark
colorscheme bandit

set ruler "Show cursor position, line, col"

" Max text width, 0 to disable it
set textwidth=0

" Wrappe à 72 caractères avec la touche '@#'
"map @# gwap
" Wrappe et justifie à 72 caractères avec la touche '@'
"map @ {v}! par 72j

set nocompatible
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
"set noautoindent
set autoindent
set smartindent
set cino+=(0,+0 "C file option
set autoread

" xterm-debian est un terminal couleur
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
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
autocmd FileType cpp setlocal foldlevel=1
autocmd FileType cpp setlocal foldnestmax=1
autocmd FileType cpp setlocal foldmarker={,}
autocmd FileType cpp setlocal foldminlines=5

set incsearch " Search as we type
set hlsearch "Highlight

" Line number
"set number

set mouse=a
"set tags+=~/.vim/tags/project1;~/.vim/tags/project2
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
autocmd QuickFixCmdPost [^l]* nested botright cwindow " Botright to open widely
autocmd QuickFixCmdPost    l* nested botright lwindow


if &term =~ "xterm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

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


function! File_flip()
  " Switch editing between .c* and .h* files (and more).
  " Since .h file can be in a different dir, call find.
  if match(expand("%"),'\.cc') > 0
    let s:flipname = substitute(expand("%"),'\.cc\(.*\)','.hh\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),'\.hxx') > 0
    let s:flipname = substitute(expand("%"),'\.hxx\(.*\)','.hh\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.hh") > 0
    let s:flipname = substitute(expand("%"),'\.hh\(.*\)','.cc\1',"")
    if !empty(glob(s:flipname))
      exe ":e " s:flipname
    else
      let s:flipname = substitute(expand("%"),'\.hh\(.*\)','.hxx\1',"")
      exe ":e " s:flipname
    endif
  elseif match(expand("%"),"\\.h") > 0
    let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c\1',"")
    exe ":find " s:flipname
  elseif match(expand("%"),"\\.c") > 0
    let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h\1',"")
    exe ":find " s:flipname
  endif
endfun

" Custom map
map q: :q
noremap <S-Enter> O<Esc>

let mapleader=" "
noremap <leader>a :set scb<cr>
noremap <leader>A :set scb!<cr>
noremap <leader>b :FufBuffer<cr>
"map <leader>b :ls<cr>:b<space><tab> "Roots
noremap <leader>c lc^
noremap <leader>C 0D
noremap <leader>d "_d
noremap <leader>e :e<space>./
noremap <leader>g :vimgrep /<C-r><C-w>/j ./*
noremap <leader>G :e ~/.indexer_files<cr>
noremap <leader>h :call File_flip()<cr>
":e %:p:s,.hh$,.X123X,:s,.hxx$,.hh,:s,.X123X$,.hxx,<cr>
" Insert Header
noremap <leader>H :0r ~/.vim/.header_template<cr>
noremap <leader>j :ts <C-r><C-w>
noremap <leader>J <C-T>
noremap <leader>l :TagbarToggle<cr>
noremap <leader>m :mksession ~/mysession.vim
noremap <leader>n :Explore<cr>
noremap <leader>p "_dP
noremap <leader>R /\<<C-r><C-w>\><cr>:%s//
noremap <leader>s :SemanticHighlightToggle<cr>
noremap <leader>S :source ~/mysession.vim
noremap <leader>t :vsp<cr>
noremap <leader>T :sp<cr>
noremap <leader>u :GundoToggle<cr>
" Update timestamp and copyright
noremap <leader>w :Adapt<cr>:w<cr>
noremap <leader>x :q<cr>
noremap <leader>X :bd<cr>
noremap <leader>X! :bd!<cr>
noremap <leader>y "+y
noremap <leader>Z zO
noremap <leader>z zf

noremap <leader>/ :nohlsearch<cr>
noremap <leader>1 "1 ; Register
noremap <leader>2 "2 ; Register
noremap <leader>3 "3 ; Register
noremap <leader><cr> a<cr><esc>
noremap <leader>; A;<esc>
noremap <leader>> x<esc>wP
noremap <leader>< x<esc>bep

" Custom hard remap
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
"autocmd FileType c,cpp inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
autocmd FileType c,cpp inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
autocmd FileType c,cpp inoremap { {<CR>}<Esc>ko

" Split naviguation
" silent help to not ask anything in the command
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j


" Simulate <down> after CTRL-N
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

filetype on
au BufNewFile,BufRead *.rs set filetype=rust

filetype plugin on
syntax on

" French spelling
augroup filetypedetect
au BufNewFile,BufRead *.tex setlocal spell spelllang=fr
augroup END
set nospell

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


"cd %:p:h " change current directory at boot up *Not working*
set autochdir

" Tagbar options
""""""""""""""""""
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1

hi CursosLine gui=underline
if ! exists('g:TagHighlightSettings')
let g:TagHighlightSettings = {}
endif

let g:rainbow_active=1

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set hidden " Keep buffers hidden instead of closing it

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
\       'replacement': strftime('%a %b %d %H:%M:%S %Y Thomas Legris'),
\	    'range': '1,10'
\   }
\]

" Language Tools
let g:languagetool_jar='$HOME/usr/bin/languagetool-commandline.jar'

" Semantic Highlight
let g:semanticColors = { 0x00: '#72d572', 0x01: '#c5e1a5', 0x02: '#e6ee9c', 0x03: '#fff59d', 0x04: '#ffe082', 0x05: '#ffcc80', 0x06: '#ffab91', 0x07: '#bcaaa4', 0x08: '#b0bec5', 0x09: '#ffa726', 0x0a: '#ff8a65', 0x0b: '#f9bdbb', 0x0c: '#f9bdbb', 0x0d: '#f8bbd0', 0x0e: '#e1bee7', 0x0f: '#d1c4e9', 0x10: '#ffe0b2', 0x11: '#c5cae9', 0x12: '#d0d9ff', 0x13: '#b3e5fc', 0x14: '#b2ebf2', 0x15: '#b2dfdb', 0x16: '#a3e9a4', 0x17: '#dcedc8' , 0x18: '#f0f4c3', 0x19: '#ffb74d' }

" Surround 
let g:surround_{char2nr("c")} = "\/*\n\r\n*\/"

" Backup part
set nobackup
"set backupdir=~/.vim/backup

" Swap file
"set noswapfile
"set directory=~/.vim/swap

" start up message short
set shortmess+=I 
nnoremap <silent> + <c-w>>
nnoremap <silent> - <c-w><
