#!/bin/bash
patch ./bundle/vim-gutentags/autoload/gutentags/ctags.vim ./patches/gutentags_ctags.patch
patch -p1 < ./patches/omnicppcomplete.patch
