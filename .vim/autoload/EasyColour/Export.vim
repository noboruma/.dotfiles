" Easy Colour:
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
try
	if &cp || (exists('g:loaded_EasyColourExport') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_EasyColourExport = 1

function! EasyColour#Export#ExportColourScheme(name)
	" Currently only supports the background colour that is currently
	" configured
	let command_list = EasyColour#ColourScheme#GetColourSchemeLoadCommands(a:name)
	let pre_commands_file = split(globpath(&rtp, 'colors/' . a:name . '.vim'), "\n")[0]
	let header_commands = readfile(pre_commands_file)

	vnew
	let lnum = 1
	for line in header_commands
		if line =~ '.*EasyColour#'
			" Comment out this line
			call setline(lnum, '" ' . line)
		else
			call setline(lnum, line)
		endif
		let lnum += 1
	endfor

	call setline(lnum, "")
	let lnum += 1

	call setline(lnum, command_list)
endfunction
