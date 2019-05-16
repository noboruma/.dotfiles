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
imap <C-l> <Plug>(neosnippet_expand)
smap <C-l> <Plug>(neosnippet_expand)
xmap <C-l> <Plug>(neosnippet_expand_target)

if has('nvim') && !use_coc
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
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
packadd tagbar
" !Tagbar

let g:airline_extensions += ['ale', 'gutentags', 'languageclient', 'tagbar']

packadd tagfinder
packadd nvim-gdb

if has('nvim') && use_coc
    packadd coc.nvim
    inoremap <silent><expr> <c-space> coc#refresh()
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
    let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <leader>la :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <leader>le :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <leader>lc :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <leader>lo :<C-u>CocList outline<cr>
    " Search workleader symbols
    nnoremap <silent> <leader>ls :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <leader>lj :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <leader>lk :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <leader>lp :<C-u>CocListResume<CR>

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
else
    let g:LanguageClient_autoStart=1
    let g:LanguageClient_diagnosticsEnable=1
    let g:LanguageClient_hasSnippetSupport=1
    let g:LanguageClient_selectionUI='quickfix'
    let g:LanguageClient_diagnosticsList='Location'
    " See ftplugin for tools setup
    if executable('ccls') || executable ('cquery')
        let g:LanguageClient_serverCommands = {}
        if executable('rls')
            let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'nightly', 'rls']
        endif
        if executable('jdtls')
            let g:LanguageClient_serverCommands.java = ['$HOME/usr/bin/jdtls', '-data', getcwd()]
        endif
        if executable('ccls')
            let g:LanguageClient_serverCommands.c = ['ccls',
                        \ '--log-file=/tmp/cc.log',
                        \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}']
            let g:LanguageClient_serverCommands.cpp = ['ccls',
                        \ '--log-file=/tmp/cc.log',
                        \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}']
        elseif executable('cquery')
            let g:LanguageClient_serverCommands.c = ['cquery',
                        \ '--init={"cacheDirectory":"/tmp/cquery/cache/",
                        \ "diagnostics": {"onParse": false, "onType": false},
                        \ "index": {"comments": 2},
                        \ "cacheFormat": "msgpack",
                        \ "completion": {"filterAndSort": false}}']
            let g:LanguageClient_serverCommands.cpp = ['cquery',
                        \ '--init={"cacheDirectory":"/tmp/cquery/cache/",
                        \ "diagnostics": {"onParse": true, "onType": true},
                        \ "index": {"comments": 2},
                        \ "cacheFormat": "msgpack",
                        \ "completion": {"filterAndSort": true}}']
        endif
    endif

    packadd LanguageClient-neovim

    if has('nvim')
        call deoplete#custom#source('LanguageClient',
                    \ 'min_pattern_length',
                    \ 2)
        call deoplete#custom#filter('attrs_order', {
                    \ 'cpp': {
                    \     'kind': [
                    \     'Method',
                    \     'Function',
                    \     'Property'
                    \     ],
                    \ },
                    \ 'c': {
                    \     'kind': [
                    \     'Function',
                    \     'Property'
                    \     ]
                    \ }
                    \})
    else
        setlocal omnifunc=LanguageClient#complete
        "set formatexpr=LanguageClient_textDocument_rangeFormatting()
    endif
    LanguageClientStart
    nnoremap <silent>gd :<c-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<cr>
    nnoremap <silent>gr :<c-u>call LanguageClient#textDocument_references()<cr>:call asyncrun#quickfix_toggle(0, 1)<cr>
    nnoremap <silent>K :<c-u>call LanguageClient#textDocument_hover()<cr>
    nnoremap <silent>gy :<c-u>call LanguageClient#textDocument_signatureHelp()<cr>
    nnoremap <silent>gc :<c-u>call LanguageClient#findLocations({'method':'$ccls/call'})<cr>
    nnoremap <silent>gC :<c-u>call LanguageClient#findLocations({'method':'$ccls/call','callee':v:true})<cr>
    nnoremap <leader>ac :<c-u>call LanguageClient#textDocument_codeAction()<cr>
endif

