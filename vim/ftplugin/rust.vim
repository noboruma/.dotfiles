packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='cargo'
"--manifest-path `pwd`/<tab><tab>
"
let g:make_extra='@ build -j4'

setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4

packadd rust.vim
let g:rustfmt_autosave = 1

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

lua <<EOM
local dap = require('dap')

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath('data')..'/mason/bin/codelldb',
    args = {"--port", "${port}"},
  }
}

dap.configurations.rust = {
  {
    name = "Rust debug",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    showDisassembly = "never",
  },
}
EOM

"" Copied from built-in compiler/{rustc,cargo}.vim
setlocal errorformat=
			\%f:%l:%c:\ %t%*[^:]:\ %m,
			\%f:%l:%c:\ %*\\d:%*\\d\ %t%*[^:]:\ %m,
			\%-G%f:%l\ %s,
			\%-G%*[\ ]^,
			\%-G%*[\ ]^%*[~],
			\%-G%*[\ ]...

" New errorformat (after nightly 2016/08/10)
setlocal errorformat+=
			\%-G,
			\%-Gerror:\ aborting\ %.%#,
			\%-Gerror:\ Could\ not\ compile\ %.%#,
			\%Eerror:\ %m,
			\%Eerror[E%n]:\ %m,
			\%Wwarning:\ %m,
			\%Inote:\ %m,
			\%C\ %#-->\ %f:%l:%c

setlocal errorformat+=
			\%-G%\\s%#Downloading%.%#,
			\%-G%\\s%#Compiling%.%#,
			\%-G%\\s%#Finished%.%#,
			\%-G%\\s%#error:\ Could\ not\ compile\ %.%#,
			\%-G%\\s%#To\ learn\ more\\,%.%#
