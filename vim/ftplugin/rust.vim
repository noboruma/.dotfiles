packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
"
let g:make_extra='@ build -j4'

set expandtab
set tabstop=4
set shiftwidth=4

packadd rust.vim
let g:rustfmt_autosave = 0

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits',
        \'i:impls,trait implementations',
    \]
\}

if !use_coc
    let g:rustfmt_autosave = 1
endif

"DefineLocalTagFinder TagFindStruct s,struct
"DefineLocalTagFinder TagFindTrait t,trait

if exists('g:rust_tools_loaded')
    finish
endif
let g:rust_tools_loaded = 1

packadd rust-tools.nvim

lua <<EOF
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

"let &efm = ''
"" Random non issue stuff
"let &efm .= '%-G%.%#aborting due to previous error%.%#,'
"let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'
"" Capture enter directory events for doc tests
"let &efm .= '%D%*\sDoc-tests %f%.%#,'
"" Doc Tests
"let &efm .= '%E---- %f - %o (line %l) stdout ----,'
"let &efm .= '%Cerror%m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'
"" Unit tests && `tests/` dir failures
"" This pattern has to come _after_ the doc test one
"let &efm .= '%E---- %o stdout ----,'
"let &efm .= '%Zthread %.%# panicked at %m\, %f:%l:%c,'
"let &efm .= '%Cthread %.%# panicked at %m,'
"let &efm .= '%+C%*\sleft: %.%#,'
"let &efm .= '%+Z%*\sright: %.%#\, %f:%l:%c,'
"" Compiler Errors and Warnings
"let &efm .= '%Eerror%m,'
"let &efm .= '%Wwarning: %m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'

if !use_coc
    let g:rustfmt_autosave = 1
endif

"DefineLocalTagFinder TagFindStruct s,struct
"DefineLocalTagFinder TagFindTrait t,trait

if exists('g:rust_tools_loaded')
    finish
endif
let g:rust_tools_loaded = 1

packadd rust-tools.nvim

lua <<EOF
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

"let &efm = ''
"" Random non issue stuff
"let &efm .= '%-G%.%#aborting due to previous error%.%#,'
"let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'
"" Capture enter directory events for doc tests
"let &efm .= '%D%*\sDoc-tests %f%.%#,'
"" Doc Tests
"let &efm .= '%E---- %f - %o (line %l) stdout ----,'
"let &efm .= '%Cerror%m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'
"" Unit tests && `tests/` dir failures
"" This pattern has to come _after_ the doc test one
"let &efm .= '%E---- %o stdout ----,'
"let &efm .= '%Zthread %.%# panicked at %m\, %f:%l:%c,'
"let &efm .= '%Cthread %.%# panicked at %m,'
"let &efm .= '%+C%*\sleft: %.%#,'
"let &efm .= '%+Z%*\sright: %.%#\, %f:%l:%c,'
"" Compiler Errors and Warnings
"let &efm .= '%Eerror%m,'
"let &efm .= '%Wwarning: %m,'
"let &efm .= '%-Z%*\s--> %f:%l:%c,'
