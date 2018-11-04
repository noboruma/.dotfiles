if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight
  au BufWritePost <buffer> :SemanticHighlight
endif

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

"inoremap <expr> < "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"

imap <expr> {<cr> "{<cr>}<esc>O"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>
inoremap <<cr> <<cr>><c-o>O<tab>

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
noremap <F4>  :botright copen\|AsyncRun -program=make @ build -j4

set expandtab
set tabstop=4
set shiftwidth=4

DefineLocalTagFinder TagFindStruct s,struct
DefineLocalTagFinder TagFindTrait t,trait

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml'))},
        \ 'whitelist': ['rust'],
        \ })
endif
