packadd nvim-treesitter
source ~/.vim/bundle/coding_activator.vim
setlocal nolist autoindent noexpandtab tabstop=4 shiftwidth=4

lua <<EOF
    vim.lsp.enable("asm_lsp")
EOF
