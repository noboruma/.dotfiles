" Easy Colour Sample:
"   Author:  A. S. Budden <abudden _at_ gmail _dot_ com>
" Copyright: Copyright (C) 2011 A. S. Budden
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            the EasyColour plugin is provided *as is* and comes with no
"            warranty of any kind, either expressed or implied. By using
"            this plugin, you agree that in no event will the copyright
"            holder be liable for any damages resulting from the use
"            of this software.

" ---------------------------------------------------------------------

" Vim Colour File based on EasyColour Plugin

set background=light

hi clear
if exists("syntax_on")
	syntax reset
endif

call EasyColour#ColourScheme#LoadColourScheme('default_modified')
