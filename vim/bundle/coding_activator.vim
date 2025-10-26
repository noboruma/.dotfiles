if exists('g:coding_activator_loaded')
    finish
endif
let g:coding_activator_loaded = 1

" Surround
let g:surround_{char2nr("t")} = "\1template: \1<\r>"

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

if !&diff
    "au BufEnter <buffer> if (!exists('b:created')) | exe "SemanticHighlight" | let b:created=1 | endif
    "Triggered by :doautocmd
    au BufEnter * :SemanticHighlight
    au BufWritePost * :SemanticHighlight
endif
" !Semantic Highlight

" Gutentags
"if executable('ctags')
"    let g:gutentags_project_root=['.git']
"    let g:gutentags_file_list_command = {
"                \ 'markers': {
"                \ '.git': 'git ls-files',
"                \ '.hg': 'hg files',
"                \ },
"                \ }
"    set statusline+=%{gutentags#statusline()}
"    set tags=./tags;,tags;
"    let g:gutentags_cache_dir='~/.tags.auto'
"    " /!\ Change plugin from setlocal to set
"    "let g:gutentags_trace=1
"    packadd vim-gutentags
"    call gutentags#setup_gutentags()
"    if(exists('b:gutentags_files'))
"        exe 'set tags^='.b:gutentags_files['ctags']
"    endif
"else
"    echom 'no ctags executable'
"endif
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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"if has('nvim') && !use_coc
"    let g:deoplete#enable_at_startup = 1
"    packadd deoplete.nvim
"    call deoplete#custom#option('ignore_sources', {'_': ['buffer', 'around', 'member']})
"
"    call deoplete#custom#option({
"                \ 'auto_complete': v:true,
"                \ 'auto_complete_delay': 100,
"                \ 'smart_case': v:true,
"                \ })
"    let g:deoplete#file#enable_buffer_path=1
"    imap <silent><expr> <TAB>
"                \ pumvisible() ? "\<lt>Down>" :
"                \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
"                \ <SID>check_back_space() ? "\<TAB>"
"                \ : deoplete#mappings#manual_complete()
"else
    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    "imap <expr><TAB>
    "     \ pumvisible() ? "\<lt>Down>" :
    "     \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
    "     \ : "\<c-r>=Smart_TabComplete()\<CR>"
"endif

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
let g:tagbar_autofocus = 0
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
packadd tagbar
" !Tagbar

"let g:airline_extensions += ['ale', 'gutentags', 'languageclient', 'tagbar']

packadd tagfinder

let g:ale_enabled = 0
" ALE plugin
if use_coc
    let g:ale_enabled = 0
else
    packadd ale
endif
"let g:ale_linters = {
"\   'cpp': ['cppcheck', 'clangtidy', 'clangcheck', 'flawfinder', 'gcc'],
"\}
let g:ale_cpp_gcc_options = '$(cat ~/.compiler_options)' "Options can be easily retrieved using 'bear' (github)
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%]%s[%severity%]'
let g:ale_set_loclist = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_cpp_cquery_cache_directory= '/tmp/cquery/cache'
let g:ale_linters = {'rust': ['analyzer']}
"!ALE

if use_coc

    packadd coc.nvim
    "u will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    inoremap <silent><expr> <c-space> coc#refresh()
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> g? :<c-u>CocAction<cr>
    nmap <silent> gD :<c-u>call CocAction('jumpDefinition', 'vsplit')<cr><c-w>=
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gt <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gR :<c-u>call asyncrun#quickfix_toggle(0,1) \| call CocAction('jumpReferences')<cr>
    nmap <silent> gL <Plug>(coc-codelens-action)
    nmap <silent> gl :<c-u>CocList symbols<cr>

    let g:coc_auto_copen = 0
    autocmd User CocQuickfixChange call asyncrun#quickfix_toggle(0, 1) -cwd=`pwd`

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    xmap <silent>g?  <Plug>(coc-codeaction-selected)
    " Remap for do codeAction of current line
    nmap <silent>g?  <Plug>(coc-codeaction-cursor)
    " Fix autofix problem of current line
    nmap <silent>g!  <Plug>(coc-fix-current)

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
    "nnoremap <silent> K :call <SID>show_documentation()<CR>
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
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    imap <silent><expr> <TAB>
                \ pumvisible() ? "\<lt>Down>" :
                \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

    command! -nargs=0 CocDetail :call CocAction('diagnosticInfo')

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

else
    packadd vscode-go
    packadd vim-vsnip
    packadd nvim-lspconfig
    packadd nvim-cmp
    packadd cmp-nvim-lsp
    packadd cmp-vsnip
    packadd cmp-path
    packadd cmp-buffer
    packadd cmp-cmdline
    packadd mason.nvim
    packadd mason-lspconfig.nvim

    nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> gt    <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> g?    <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> [g    <cmd>lua vim.diagnostic.jump({count=-1, float=true})<CR>
    nnoremap <silent> ]g    <cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>


lua <<EOF
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup{}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

--vim.lsp.enable("gopls")
--local nvim_lsp = require('lspconfig')
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { 'pyright', 'ts_ls', 'gopls', 'yamlls', 'dockerls', 'bashls', 'clangd', 'asm_lsp', 'zls', 'lua_ls', 'html', 'typos_lsp', 'cssls', 'jqls', 'harper_ls', 'ast_grep', 'golangci_lint_ls', 'yamlls'}
--for _, lsp in pairs(servers) do
--  nvim_lsp[lsp].setup {
--    on_attach = on_attach,
--    capabilities = capabilities,
--    flags = {
--      -- This will be the default in neovim 0.7+
--      debounce_text_changes = 150,
--    }
--  }
--end

--nvim_lsp.rust_analyzer.setup {
--    on_attach = on_attach,
--    flags = {
--      -- This will be the default in neovim 0.7+
--      debounce_text_changes = 150,
--    },
--    cmd = {vim.fn.stdpath('data')..'/mason/bin/rust-analyzer'},
--    settings = {
--        ["rust-analyzer"] = {
--            cargo = {
--                -- FIXME: make generic
--                target = "x86_64-unknown-linux-gnu"
--            },
--            check = {
--                command = "clippy",
--                extraArgs = { "--", "-W", "clippy::all", "-D", "warnings" },
--            },
--        },
--    },
--}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local cmp = require('cmp')
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- Installed sources
  sources = {
    { name = 'nvim_lsp', priority = 100 },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'buffer' },
    { name = 'cmdline' },
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<Tab>"] = cmp.mapping(function(fallback)
    if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t("<cr>"), "")
    elseif vim.fn["vsnip#available"](1) == 1 then
        vim.fn.feedkeys(t("<Plug>(vsnip-expand-or-jump)"), "")
    elseif check_back_space() then
        vim.fn.feedkeys(t("<Tab>"), "")
    else
        fallback()
    end
    end, { "i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function()
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
    else
        fallback()
    end
    end, {"i", "s"}),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
      }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})

cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
                { name = 'buffer' }
        }
})
EOF

endif

"packadd vimproc.vim

packadd vim-test
if has('nvim')
    " Untested, use asynrun otherwise
    let test#strategy = 'neovim'
endif
nmap <leader>t :<c-u>TestNearest<cr>
nmap <leader>T :<c-u>TestNFile<cr>

"packadd Vim-code-browse
"packadd neoformat

packadd splitjoin.vim

if has('nvim')
packadd nvim-treesitter
packadd godbolt.nvim
lua << EOF
require("godbolt").setup({
    languages = {
        c = { compiler = "cg112", options = {} },
        cpp = { compiler = "g112", options = {} },
        rust = { compiler = "r1600", options = {} },
        go = { compiler = "gccgo113", options = {} },
        -- any_additional_filetype = { compiler = ..., options = ... },
        },
    quickfix = {
        enable = true, -- whether to populate the quickfix list in case of errors
        auto_open = false -- whether to open the quickfix list if the compiler outputs errors
        },
    url = "https://godbolt.org" -- can be changed to a different godbolt instance
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "cpp", "yaml", "json", "go" },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
      enable = true
  },
}
EOF
endif

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
