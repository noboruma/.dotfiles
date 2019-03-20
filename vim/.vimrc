" .Vimrc from Thomas Legris 28/06/2014
" Useful regex stuff:
" %s/\<word\>\C/new/g -> \< match begin \> match end \C case sensistiveness
" copy command output:
" redir @* | cmd | redir END
set shell=zsh
" Script Setting
let use_arrow=0
let use_gui=0
let use_custhelp=0
let username="Thomas Legris"

set nocompatible

"  If you need infrmation on parameters, use :h param
if has("gui_running")
    set guifont=Terminus\ 10
    if &guifont != 'Terminus 10'
        set guifont=Monospace\ 9
    endif
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

set ttyfast
set re=1
set lazyredraw
set scrolloff=0 " Keep no lines after/before the cursor

" Start to be a good vimmer
if !use_arrow
    inoremap  <Left>   <NOP>
    inoremap  <Right>  <NOP>
    nnoremap  <Up>     <NOP>
    nnoremap  <Down>   <NOP>
    nnoremap  <Left>   <NOP>
    nnoremap  <Right>  <NOP>
endif

set cmdheight=1
set vb                         " visual bell
syntax on                      " enable
set background=dark
colorscheme myslate

set nosmd
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
set cino+=j1,(0,b1,+0,t0,<0      " C file option
set autoread
set clipboard=unnamed          " ^=
set showcmd                    " visual count

" set terminal, needed this way to support C-arrows.
" Looks like vim is only parsing 'xterm' to make decisions
set term=xterm-256color

" Show space and tab as blue
set list
set listchars=tab:>-,trail:-

"set ignorecase
set smartcase
" as ignore case but not if one Capital letter

" Folding
" Trigger manual after indent method
augroup vimrc
    au BufReadPre  * setlocal foldmethod=expr
    au BufWinEnter * if &fdm == 'expr' | setlocal foldmethod=manual | normal zM | endif
    " Prevent RO file editing: use 'set modifiable' manually if needed
    autocmd BufRead * let &modifiable = !&readonly
augroup END

set foldlevel=99
set foldnestmax=0

set incsearch      " Search as we type
set hlsearch       " Highlight

set mouse=a

set matchpairs+=<:>

filetype off

" ALE plugin
let &runtimepath.=',~/.vim/bundle/ale'
let g:ale_linters = {
\   'cpp': ['cppcheck', 'clangtidy', 'clangcheck', 'flawfinder', 'gcc'],
\}
let g:ale_cpp_gcc_options = '$(cat ~/.compiler_options)' "Options can be easily retrieved using 'bear' (github)
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%]%s[%severity%]'
let g:ale_set_loclist = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_cpp_cquery_cache_directory= '/tmp/cquery/cache'
"!ALE

" airline plugin
set laststatus=2 "status bar
let g:airline_theme='light'
let g:airline_highlighting_cache=1
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
let g:airline_section_z = '%3l:%2c%#__accent_bold#%3p%%%#__restore__#' "can add variable via %{g:airline_right_sep}
let g:airline_extensions = ['quickfix', 'undotree', 'unite']
let &runtimepath.=',~/.vim/bundle/airline'
let &runtimepath.=',~/.vim/bundle/airline-themes'
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#ale#enabled = 1
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
let g:slime_target = "tmux"
"!Slime

"Undo tree
let &runtimepath.=',~/.vim/bundle/undotree'
"!Undo

" AsyncRun
let &runtimepath.=',~/.vim/bundle/asyncrun'
let g:asyncrun_bell=1
" !AsyncRun

" Restful-console
let &runtimepath.=',~/.vim/bundle/vim-rest-console'
let g:vrc_curl_opts = {
            \ '--connect-timeout' : 10,
            \ '-L': '',
            \ '-i': '',
            \ '--max-time': 60,
            \ '--ipv4': '',
            \ '-k': '',
            \ '-v': '',
            \}
"!Restful-console

" Unite.vim
let &runtimepath.=',~/.vim/bundle/unite.vim'
call unite#custom#profile('default', 'context', {
            \   'start_insert': 1,
            \   'winheight': 10,
            \   'direction': 'botright'
            \ })
"!Unite.vim

" Linediff
let &runtimepath.=',~/.vim/bundle/linediff.vim'
" !Linediff

" wordmotion
let &runtimepath.=',~/.vim/bundle/vim-wordmotion'
" !wordmotion

" vim-textobj
let &runtimepath.=',~/.vim/bundle/vim-textobj-user'
let &runtimepath.=',~/.vim/bundle/vim-textobj-function'
let &runtimepath.=',~/.vim/bundle/vim-textobj-parameter'
let &runtimepath.=',~/.vim/bundle/vim-textobj-variable-segment'
let &runtimepath.=',~/.vim/bundle/vim-textobj-xmlattr'
" !vim-textobj

" Tabular
let &runtimepath.=',~/.vim/bundle/tabular'
" !Tabular

" EasyMotion
let &runtimepath.=',~/.vim/bundle/vim-easymotion'
nmap s <Plug>(easymotion-overwin-w)
" !EasyMotion

" vim-repeat
let &runtimepath.=',~/.vim/bundle/vim-repeat'
" !vim-repeat

" vim-notes
let &runtimepath.=',~/.vim/bundle/vim-misc'
let &runtimepath.=',~/.vim/bundle/vim-notes'
let g:notes_directories = ['~/Dropbox/notes']
" !vim-orgmode

" Auto adapt
let &runtimepath.=',~/.vim/bundle/vim-ingo-library'
" Timestamp
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
            \       'name': 'Copyright notice modelines',
            \       'patternexpr': '''\c\<Copyright:\?\%(\s\+\%((C)\|&copy;\|\%xa9\)\)\?\s\+\zs\(\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\%(\ze\k\@![^-]\|\(-\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\>\)''',
            \       'replacement': '\=submatch(1) . "-" . strftime("%Y")',
            \       'range': 'modelines'
            \   },
            \   {
            \       'name': 'Last Change notice',
            \       'pattern': '\v\C%(<Last %([uU]pdate?|[Mm]odified)\s+)@<=.*$',
            \       'replacement': '\=strftime("%a %b %d %H:%M:%S %Y '.username.'")',
            \	    'range': '1,10'
            \   }
            \]
autocmd BufWritePre <buffer> silent! :Adapt
"!Auto Adapt

"vim-which-key
let mapleader="\<Space>"
if use_custhelp
    packadd vim-which-key
    nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
endif
"!vim-which-key

"fzf
if(isdirectory($HOME."/.fzf"))
    "ln -s the fzf source directory for your own good
    let &runtimepath.=',~/.fzf'
    let &runtimepath.=',~/.vim/bundle/fzf.vim'
    let g:fzf_buffers_jump = 1
    "   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
    "   :Ag! - Start fzf in fullscreen and display the preview window above
    command! -bang -nargs=* Ag
                \ call fzf#vim#ag(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
                \                 <bang>0)

    " Likewise, Files command with preview window
    command! -bang -nargs=* -complete=dir Files
                \ call fzf#vim#files(<q-args>,
                \                    <bang>0 ? fzf#vim#with_preview('up:70%')
                \                            : fzf#vim#with_preview('right:50%:hidden', '?'),
                \                    <bang>0)
else
    echom 'fzf not installed'
endif
"!fzf

" Termdebug
let g:termdebug_popup=0
let no_buffers_menu=0
let termdebugger = "gdb"
packadd termdebug
" !Termdebug

filetype on
filetype plugin on
filetype indent on
set ruler          " Relative cursor position
set is             " inc search

if has("gui_running")
    set cul        " Highlight current line
    hi CursosLine gui=underline
else
    set nocul      " Speed up vim
endif

set spelllang=en
set nospell
" c-x c-k feature:
set dictionary+=/usr/share/dict/words

" Make options
let &makeprg='make'

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
    autocmd User AsyncRunStart botright copen | setl nomodifiable | setl foldlevel=99 | let g:jumpfirst=1 | wincmd p
    autocmd User AsyncRunStop call AutoAdjustQFWindow()
augroup END

" Handle space and tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Allow real tab in leader mapping
set wildcharm=<tab>
set timeoutlen=500 ttimeoutlen=10

source ~/.vim/custmap.vim

" Explorer options
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=delete
"set winfixwidth

" Ced: for auto-completion popup menu
highlight Pmenu    guifg=black  guibg=grey
highlight PmenuSel guifg=grey guibg=black gui=bold
" Thomas: let's change it for term as well
highlight Pmenu    ctermbg=grey gui=bold
highlight PmenuSel ctermbg=cyan gui=bold
"hi Search cterm=NONE ctermfg=grey ctermbg=blue

set completeopt=menu,menuone,longest
",preview
set previewheight=3
"To close automatically the preview window:
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set showbreak=↪
set wrap
set cpo+=n

set autochdir

" Jump to the last position when reopening a file
augroup vimrc
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " Adapt on save hook
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd BufWritePre <buffer> silent! :Adapt
augroup END

" Keep buffers hidden instead of closing it
set hidden

" More natural split opening
set splitbelow
set splitright

" Backup part
set nobackup
"set backupdir=~/.vim/vimfiles/backup

" Swap files
set noswapfile
"set directory=~/.vim/vimfiles/swap

" Undo files
if has('persistent_undo')
    set undodir=~/.vim/vimfiles/undo
    set undofile
    set undolevels=1024
    set undoreload=1024
endif

" start up message short
set shortmess+=I

" Colorizer
let g:colorizer_nomap = 1
let g:colorizer_startup = 0

set modeline

" session
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop+=localoptions

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
endif

if &diff
    "syntax off
    set undolevels=-1
endif
