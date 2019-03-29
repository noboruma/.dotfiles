" Semantic Highlight
let g:semanticGUIColors = [
            \'#5fd7ff',
            \'#d75f5f',
            \'#87afd7',
            \'#875faf',
            \'#5f87d7',
            \'#c0c0c0',
            \'#808080',
            \'#d75f00',
            \'#afffaf',
            \'#ffff00',
            \'#d7af87',
            \'#d787af',
            \'#00af5f',
            \'#5f5faf',
            \'#5fd75f',
            \'#ff87af',
            \'#ffffaf',
            \'#b2ebf2',
            \'#b2dfdb',
            \'#a3e9a4',
            \'#dcedc8',
            \'#f0f4c3',
            \'#ffb74d' ]
let g:semanticTermColors = [195,3,4,5,6,7,8,9,10,11,12,13,14,15,22,44,61,77,211, 229]
let g:semanticPersistCache = 1
packadd semantic-highlight.vim

"if has("gui_running")
    if !&diff
        au BufEnter <buffer> if (!exists('b:created')) | exe "SemanticHighlightToggle" | let b:created=1 | endif
        "Triggered by :doautocmd
        "au User <buffer> :SemanticHighlight
        au BufWritePost <buffer> :SemanticHighlight
    endif
"endif
" !Semantic Highlight

" Gutentags
if executable('ctags')
    let g:gutentags_project_root=['.git']
    let g:gutentags_file_list_command = {
                \ 'markers': {
                \ '.git': 'git ls-files',
                \ '.hg': 'hg files',
                \ },
                \ }
    set statusline+=%{gutentags#statusline()}
    set tags=./tags;,tags;
    let g:gutentags_cache_dir='~/.tags.auto'
    " /!\ Change plugin from setlocal to set
    "let g:gutentags_trace=1
    packadd vim-gutentags
    call gutentags#setup_gutentags()
    if(exists('b:gutentags_files'))
        exe 'set tags^='.b:gutentags_files['ctags']
    endif
else
    echom 'no ctags executable'
endif
" !Gutentags

" Ultisnips
packadd ultisnips
packadd vim-snippets
let g:ulti_expand_res = 0 "default value, just set once
function! CompleteSnippet()
    if empty(v:completed_item)
        return
    endif

    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res > 0
        return
    endif

    let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
    let l:comp_len = len(l:complete)

    let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
    let l:cur_line = getline('.')

    let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
    let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''

    call setline('.', l:start . l:end)
    call cursor('.', l:cur_col - l:comp_len + 2)

    call UltiSnips#Anon(l:complete)
endfunction

autocmd CompleteDone * call CompleteSnippet()
let g:UltiSnipsExpandTrigger="<NUL>"
let g:UltiSnipsListSnippets="<NUL>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"!Ultisnips

" Snipmate
packadd tlib
packadd vim-addon-mw-utils
packadd vim-snipmate
imap <C-J> <Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger
" !Snipmate

" Tagbar options
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
packadd tagbar
let g:airline_extensions += ['tagbar']
" !Tagbar


let g:airline_extensions = ['ale', 'gutentags', 'languageclient', 'quickfix', 'tagbar', 'undotree', 'unite']

packadd tagfinder
