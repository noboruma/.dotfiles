#!/bin/bash
patch ./bundle/vim-gutentags/autoload/gutentags/ctags.vim ./patches/gutentags_ctags.patch
patch ./after/plugin/snipMate.vim ./patches/snipMate.patch
