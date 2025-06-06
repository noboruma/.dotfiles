packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim

lua <<EOF
    vim.lsp.enable("ast_grep")
    vim.lsp.enable("harper_ls")
    vim.lsp.enable("lua_ls")
EOF
