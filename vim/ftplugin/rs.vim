let &runtimepath.=',~/.vim/bundle/rust'

if has("gui_running")
  au BufEnter <buffer> if (!exists('b:created')) | :execute "SemanticHighlight" | let b:created=1 | endif
  "Triggered by :doautocmd
  "au User <buffer> :SemanticHighlight
  au BufWritePost <buffer> :SemanticHighlight
endif

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"
set expandtab

inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> { "{}\<Left>"
inoremap ;; <esc>g_a;
inoremap ,, <esc>g_a,
inoremap ;. <esc>g_a.

imap <expr> {<cr> "{<cr>}<esc>=2kO"
inoremap [<cr> [<cr>]<c-o>O<tab>
inoremap (<cr> (<cr>)<c-o>O<tab>

inoremap <expr> <> "<>\<Left>"
inoremap <expr> > strpart(getline('.'), col('.')-1, 1) == ">" ? "\<Right>" : ">"
