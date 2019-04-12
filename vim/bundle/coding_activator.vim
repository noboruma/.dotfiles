if exists('g:coding_activator_loaded')
  finish
endif
let g:coding_activator_loaded = 1

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

" neosnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory=['~/.vim/pack/submodules/opt/vim-snippets/snippets', '~/.vim/bundle/custom-snippets']

packadd neosnippet.vim
imap <C-j> <Plug>(neosnippet_expand)
smap <C-j> <Plug>(neosnippet_expand)
xmap <C-j> <Plug>(neosnippet_expand_target)

if has('nvim')
    let g:python3_host_prog = '/home/tlegris/usr/bin/python3'
    let g:deoplete#enable_at_startup = 1
    packadd deoplete.nvim
    call deoplete#enable()
    call deoplete#custom#option({
                \ 'auto_complete': v:true,
                \ 'auto_complete_delay': 100,
                \ 'smart_case': v:true,
                \ })
    let g:deoplete#file#enable_buffer_path=1
    imap <silent><expr> <TAB>
                \ pumvisible() ? "\<lt>Down>" :
                \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
                \ <SID>check_back_space() ? "\<TAB>"
                \ : deoplete#mappings#manual_complete()
    function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}
else
    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    imap <expr><TAB>
         \ pumvisible() ? "\<lt>Down>" :
         \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" 
         \ : "\<c-r>=Smart_TabComplete()\<CR>"
endif

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif
"!neosnippet

" Snipmate
"packadd vim-snippets
"packadd tlib
"packadd vim-addon-mw-utils
"packadd vim-snipmate
"imap <C-J> <Plug>snipMateNextOrTrigger
"smap <C-J> <Plug>snipMateNextOrTrigger
" !Snipmate

" Tagbar options
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
packadd tagbar
" !Tagbar

let g:airline_extensions += ['ale', 'gutentags', 'languageclient', 'tagbar']

packadd tagfinder
