source ~/.vim/bundle/coding_activator.vim

lua <<EOF
    vim.lsp.enable("dockerls")
    vim.lsp.enable("docker_compose_language_ls")
EOF
