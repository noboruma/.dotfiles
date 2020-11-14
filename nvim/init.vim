set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

packadd nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF
lua <<EOF
require'nvim-treesitter.configs'.setup {
textobjects = {
    select = {
        enable = true,
        keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- Or you can define your own textobjects like this
            ["iF"] = {
                python = "(function_definition) @function",
                cpp = "(function_definition) @function",
                c = "(function_definition) @function",
                java = "(method_declaration) @function",
                },
            },
        },
    },
}
EOF

packadd iswap.nvim
lua <<EOF
require('iswap').setup{
  keys = '1234567890qwertyuiop',
  grey = 'enable',
  hl_snipe = 'Search',
  hl_selection = 'Visual',
  hl_grey = 'Comment'
}
EOF
