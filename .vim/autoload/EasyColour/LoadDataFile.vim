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
	if &cp || (exists('g:loaded_EasyColourLoadDataFile') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_EasyColourLoadDataFile = 1

let s:plugin_paths = split(globpath(&rtp, 'autoload/EasyColour/ColourScheme.vim'), '\n')
if len(s:plugin_paths) == 1
	let s:easycolour_install_path = fnamemodify(s:plugin_paths[0], ':p:h:h:h')
elseif len(s:plugin_paths) == 0
	echoerr "Cannot find ColourScheme.vim"
else
	echoerr "Multiple plugin installs found: something has gone wrong!"
endif

function! EasyColour#LoadDataFile#LoadColourSpecification(name)
	let filename = split(globpath(&rtp, 'colors/' . a:name . '.txt'), '\n')[0]
	return s:LoadFile(filename)
endfunction

function! s:LoadFile(filename)
	let result = {}
	let entries = readfile(a:filename)
	
	let top_key = ''
	for entry in entries
		" Remove white-space on the end of the line
		let entry = substitute(entry, '\s\+$', '', '')
		if entry[0] == '#'
			" Comment: ignore
		elseif entry[0] =~ '\k'
			" Keyword character first, so not sub entry or top-levelcomment
			if entry[len(entry)-1:] == ":"
				" Beginning of a field, but we don't know whether
				" it's a list of a dict yet
				let top_key = entry[:len(entry)-2]
			elseif stridx(entry, ':') != -1
				" This is key:value, so it's a simple dictionary entry
				let parts = split(entry, ':')
				" Rather coarse replacement of split(x,y,n)
				if len(parts) > 2
					let parts[1] = join(parts[1:], ':')
				endif
				if stridx(parts[1], ',') != -1
					" This entry is a list
					let result[parts[0]] = split(parts[1], ',')
				else
					let result[parts[0]] = parts[1]
				endif
				" Clear the top key as this isn't a multi-line entry
				let top_key = ''
			else
				echoerr "  Unhandled line: '" . entry . "'"
			endif
		elseif top_key != '' && entry =~ '^\s\+'
			" This is a continuation of a top level key
			let details = substitute(entry, '^\s\+', '', '')
			if details[0] == '#'
				" Comment: ignore
			elseif stridx(details, ':') != -1
				" The key is a dictionary:
				if ! has_key(result, top_key)
					let result[top_key] = {}
				endif
				" Handle the entry (without the preceding tab)
				let parts = split(details, ':')
				if len(parts) < 2
					echoerr "Invalid entry: '" . details . "'"
				endif
				" Rather coarse replacement of split(x,y,n)
				if len(parts) > 2
					let parts[1] = join(parts[1:], ':')
				endif
				" If there are multiple keys, apply the 
				" right-hand side to all keys
				let keys = split(parts[0],',')
				for key in keys
					if stridx(parts[1], ',') != -1
						" This entry is a list
						let result[top_key][key] = split(parts[1], ',')
					else
						let result[top_key][key] = parts[1]
					endif
				endfor
			else
				echoerr "Type mismatch on line '".entry."': expected key:value"
			endif
		else
			" Probably a comment or blank line
		endif
	endfor
	return result
endfunction
