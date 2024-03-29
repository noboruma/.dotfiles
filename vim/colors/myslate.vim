"%% SiSU Vim color file
" Slate Maintainer: Ralph Amissah <ralph@amissah.com>
" (originally looked at desert Hans Fugal <hans@fugal.net> http://hans.fugal.net/vim/colors/desert.vim (2003/05/06)

hi clear

set background=dark

if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let colors_name = "myslate"

hi   Normal         guifg=White            guibg=black
hi   Cursor         guibg=khaki            guifg=slategrey
hi   MatchParen     gui=underline guibg=black     cterm=underline        ctermbg=blue        ctermfg=blue
hi   CursorLine                                                cterm=underline   ctermbg=NONE         guibg=grey11
hi   VertSplit      guibg=#c2bfa5          guifg=grey40        gui=none          cterm=reverse
hi   Folded         guibg=black            guifg=grey40        ctermfg=grey      ctermbg=darkgrey
hi   FoldColumn     guibg=black            guifg=grey20        ctermfg=4         ctermbg=7
hi   IncSearch      guifg=white            guibg=blue          cterm=none        ctermfg=yellow       ctermbg=green
hi   ModeMsg        guifg=goldenrod        cterm=none          ctermfg=brown
hi   MoreMsg        guifg=SeaGreen         ctermfg=darkgreen
hi   NonText        guifg=RoyalBlue        guibg=black         cterm=bold        ctermfg=blue
hi   Question       guifg=springgreen      ctermfg=green
hi   Search         guibg=purple           guifg=grey          cterm=none        ctermfg=grey         ctermbg=blue
hi   SpecialKey     guifg=yellowgreen      ctermfg=darkgreen
hi   StatusLine     guibg=#c2bfa5          guifg=black         gui=none          cterm=bold,reverse
hi   StatusLineNC   guibg=#c2bfa5          guifg=grey40        gui=none          cterm=reverse
hi   Title          guifg=gold             gui=bold            cterm=bold        ctermfg=yellow
hi   Statement      guifg=CornflowerBlue   ctermfg=lightblue
hi   Visual         gui=none               guifg=khaki         guibg=olivedrab   cterm=reverse
hi   WarningMsg     guifg=salmon           ctermfg=1
hi   String         guifg=SkyBlue          ctermfg=darkcyan
hi   Comment        term=bold              ctermfg=11          guifg=grey40
hi   Constant       guifg=#ffa0a0          ctermfg=brown
hi   Special        guifg=darkkhaki        ctermfg=brown
hi   Identifier     guifg=salmon           ctermfg=red
hi   Include        guifg=red              ctermfg=red
hi   PreProc        guifg=red              guibg=black         ctermfg=red
hi   Operator       guifg=Red              ctermfg=Red
hi   Define         guifg=gold             gui=bold            ctermfg=yellow
hi   Type           guifg=CornflowerBlue   ctermfg=69
hi   Function       guifg=navajowhite      ctermfg=brown
hi   Structure      guifg=salmon           ctermfg=lightred
hi   LineNr         guifg=grey50           ctermfg=3
hi   Ignore         guifg=grey40           cterm=bold          ctermfg=7
hi   Todo           guifg=orangered        guibg=yellow2
hi   Directory      ctermfg=darkcyan
hi   ErrorMsg       cterm=bold             guifg=White         guibg=Red         cterm=bold           ctermfg=7       ctermbg=1
hi   VisualNOS      cterm=bold,underline
hi   WildMenu       ctermfg=0              ctermbg=3
hi   Underlined     cterm=underline        ctermfg=5
hi   Error          guifg=White            guibg=Red           cterm=bold        ctermfg=7            ctermbg=1
hi   SpellErrors    guifg=White            guibg=Red           cterm=bold        ctermfg=7            ctermbg=1
hi   SignColumn     ctermbg=black          guibg=black
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl
    hi SpellCap    guisp=#7070F0 gui=undercurl
    hi SpellLocal  guisp=#70F0F0 gui=undercurl
    hi SpellRare   guisp=#FFFFFF gui=undercurl
endif
hi DiffText    ctermbg=NONE ctermfg=Yellow cterm=NONE guibg=NONE guifg=#FFFF00 gui=NONE
hi DiffChange  ctermbg=NONE ctermfg=brown  cterm=NONE guibg=NONE guifg=#A52A2A gui=NONE
hi DiffAdd     ctermbg=NONE ctermfg=46     cterm=NONE guibg=NONE guifg=#00FF00 gui=NONE
hi DiffDelete  ctermbg=NONE ctermfg=196    cterm=NONE guibg=NONE guifg=#FF0000 gui=NONE
hi diffAdded   ctermbg=NONE ctermfg=46     cterm=NONE guibg=NONE guifg=#00FF00 gui=NONE
hi diffRemoved ctermbg=NONE ctermfg=196    cterm=NONE guibg=NONE guifg=#FF0000 gui=NONE
