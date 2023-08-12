packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim

" Make options
let &makeprg='cargo'
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
    name = "Debug",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    showDisassembly = "never",
  },
  {
    name = "Attach",
    type = "codelldb",
    mode = "local",
    request = "attach",
    processId = require("dap.utils").pick_process,
    stopOnEntry = true,
    showDisassembly = "never",
  },

}
EOM
