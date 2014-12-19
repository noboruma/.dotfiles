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
	if &cp || (exists('g:loaded_EasyColourColourScheme') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_EasyColourColourScheme = 1

let s:need_to_write_cache = 0
if ! exists('g:EasyColourDebug')
	let g:EasyColourDebug = 0
endif

function! EasyColour#ColourScheme#LoadColourScheme(name)
	let command_list = EasyColour#ColourScheme#GetColourSchemeLoadCommands(a:name)
	for command in command_list
		if g:EasyColourDebug == 1
			echomsg command
		endif
		exe command
	endfor
	if s:need_to_write_cache == 1
		call EasyColour#Translate#WriteColourCache()
		let s:need_to_write_cache = 0
	endif
	let g:colors_name = a:name
endfunction

function! EasyColour#ColourScheme#GetColourSchemeLoadCommands(name)
	let ColourScheme = EasyColour#LoadDataFile#LoadColourSpecification(a:name)
	let command_list = []

	if ! has_key(ColourScheme, 'Colours')
		let ColourScheme['Colours'] = {}
	endif

	" Used by the colour scheme file highlighter
	let g:EasyColourCustomColours = ColourScheme['Colours']

	if has_key(ColourScheme, 'Background')
		let &background = tolower(ColourScheme['Background'])
	endif

	let has_basis = 0
	if has_key(ColourScheme, 'Basis')
		if ColourScheme['Basis'] != 'None'
			let command_list += ['runtime! ' . 'colors/' . ColourScheme['Basis'] . '.vim']
			let has_basis = 1
		endif
	endif

	let auto_colour = 0
	if has_key(ColourScheme, 'DarkAuto') && has_key(ColourScheme, 'Light') && &background == 'dark'
		if index(['1', 'true'], tolower(ColourScheme['DarkAuto'])) != -1
			let auto_colour = 1
		endif
	elseif has_key(ColourScheme, 'LightAuto') && has_key(ColourScheme, 'Dark') && &background == 'light'
		if index(['1', 'true'], tolower(ColourScheme['LightAuto'])) != -1
			let auto_colour = 1
		endif
	endif

	if has_key(ColourScheme, 'Dark') && &background == 'dark'
		let details = 'Dark'
		let handler = 'Standard'
	elseif has_key(ColourScheme, 'Light') && &background == 'light'
		let details = 'Light'
		let handler = 'Standard'
	elseif auto_colour == 1 && &background == 'light'
		" These checks may need to be made more complicated
		" to include checking of LightAuto etc
		let details = 'Light'
		let basis = 'Dark'
		let handler = 'Auto'
	elseif auto_colour == 1 && &background == 'dark'
		" These checks may need to be made more complicated
		" to include checking of DarkAuto etc
		let details = 'Dark'
		let basis = 'Light'
		let handler = 'Auto'
	else
		echoerr "No colour customisations defined"
	endif

	if handler == 'Standard'
		if ! has_basis && ! has_key(ColourScheme[details], 'Normal')
			if &background == 'dark'
				let ColourScheme[details]['Normal'] = ["White","Black"]
			else
				let ColourScheme[details]['Normal'] = ["Black","White"]
			endif
		endif
		let command_list += s:StandardHandler(ColourScheme, details)
	elseif handler == 'Auto'
		let command_list += s:AutoHandler(ColourScheme, basis, details)
	endif
	return command_list
endfunction

let s:gui_fields = {'FG': 'guifg', 'BG': 'guibg', 'Style': 'gui', 'SP': 'guisp'}
let s:cterm_fields = {'FG': 'ctermfg', 'BG': 'ctermbg', 'Style': 'cterm', 'SP': 'ctermfg'}
let s:all_fields = {'guifg': 'FG', 'guibg': 'BG', 'gui': 'Style', 'guisp': 'SP', 'ctermfg': 'FG', 'ctermbg': 'BG', 'cterm': 'Style', "term": 'Style', "font": 'None'}
let s:field_order = ["FG","BG","SP","Style"]

function! s:GetColourMap()
	if has("gui_running")
		let colour_map = 'None'
	else
		if &t_Co == 256
			let colour_map = 'CT256'
		elseif &t_Co == 16
			let colour_map = 'CT16'
		elseif &t_Co == 8
			let colour_map = 'CT8'
		else
			echoerr "Unrecognised terminal colour count"
		endif
	endif
	return colour_map
endfunction

function! s:GenerateColourMap(Colours)
	if has("gui_running")
		let field_map = s:gui_fields
	else
		let field_map = s:cterm_fields
	endif

	let field_colour_map = {}
	for hlgroup in keys(a:Colours)
		if hlgroup !~ '^\k*$'
			echoerr "Invalid highlight group: '" . hlgroup . "'"
		endif

		if type(a:Colours[hlgroup]) == type([])
			let group_colours = a:Colours[hlgroup]
		else
			let group_colours = [a:Colours[hlgroup]]
		endif

		" Links
		if len(group_colours) == 1 && group_colours[0][0] == '@'
			let field_colour_map[hlgroup] = {'Link': group_colours[0][1:]}
			continue
		endif

		let highlight_map = {}
		let index = 0
		let handled = []
		for part in group_colours
			if stridx(part, '=') != -1
				let definition = split(part, '=')
				if has_key(field_map, definition[0])
					let internal_name = definition[0]
				elseif index(s:field_order, definition[0])
					" Probably supported by GUI and not CTERM... skip silently
					continue
				else
					echoerr "Unrecognised field: '" . definition[0] . "' with entry '" . hlgroup . "'"
				endif
				let colour_name = definition[1]
			else
				let internal_name = s:field_order[index]
				let colour_name = part
			endif
			let field = field_map[internal_name]

			if internal_name == 'SP' && field != 'guisp' && has_key(highlight_map, field)
				" Skip this as we're probably in a terminal Vim,
				" so guisp is meaningless and the mapped entry
				" has already been set.
			else
				let handled += [field]
				let highlight_map[field] = colour_name
			endif
			let index += 1
		endfor
		for field in keys(s:all_fields)
			if index(handled, field) == -1
				let highlight_map[field] = 'NONE'
			endif
		endfor
		let field_colour_map[hlgroup] = highlight_map
	endfor
	return field_colour_map
endfunction

function! s:StandardHandler(ColourScheme, details)
	let Colours = a:ColourScheme[a:details]
	let field_colour_map = s:GenerateColourMap(Colours)
	let colour_map = s:GetColourMap()

	let modified_colours = {}
	for hlgroup in keys(field_colour_map)
		let modified_colours[hlgroup] = {}
		if has_key(field_colour_map[hlgroup], 'Link')
			" This is a link entry: just copy across
			let modified_colours[hlgroup] = field_colour_map[hlgroup]
			continue
		endif
		for field in keys(field_colour_map[hlgroup])
			if s:all_fields[field] != 'Style' && has_key(a:ColourScheme['Colours'], field_colour_map[hlgroup][field])
				let field_colour_map[hlgroup][field] = a:ColourScheme['Colours'][field_colour_map[hlgroup][field]]
			endif

			if colour_map == 'None' || s:all_fields[field] == 'Style'
				let modified_colours[hlgroup][field] = field_colour_map[hlgroup][field]
			elseif field_colour_map[hlgroup][field] == 'NONE'
				let modified_colours[hlgroup][field] = 'NONE'
			else
				let s:need_to_write_cache = 1
				let modified_colours[hlgroup][field] = 
							\ EasyColour#Translate#FindNearest(colour_map, field_colour_map[hlgroup][field])
			endif
		endfor
	endfor
	return s:RunHighlighter(modified_colours)
endfunction

function! s:RunHighlighter(map)
	let command_list = []
	for hlgroup in ['EasyColourNormalForce'] + keys(a:map)
		" Force Normal to be handled first...
		if hlgroup == 'Normal'
			continue
		elseif hlgroup == 'EasyColourNormalForce'
			if has_key(a:map, 'Normal')
				let hlgroup = 'Normal'
			else
				continue
			endif
		endif

		if has_key(a:map[hlgroup], 'Link')
			let command = 'hi link ' . hlgroup . ' ' . a:map[hlgroup]['Link']
		else
			let command = 'hi ' . hlgroup
			for field in keys(a:map[hlgroup])
				let command .= ' ' . field . '=' . a:map[hlgroup][field]
			endfor
		endif
		let command_list += ['hi clear ' . hlgroup, command]
	endfor
	return command_list
endfunction

function! s:AutoHandler(ColourScheme, basis, details)
	let standard_field_colour_map = s:GenerateColourMap(a:ColourScheme[a:basis])
	" We'll assume that automatic generation has been enabled
	" (it's checked above)
	let colour_map = s:GetColourMap()

	" Get override map
	if has_key(a:ColourScheme, a:details . 'Override')
		let override_map = s:GenerateColourMap(a:ColourScheme[a:details . 'Override'])
	else
		let override_map = {}
	endif
	
	" First, make colours darker or lighter as appropriate
	let modified_colours = {}
	for hlgroup in keys(standard_field_colour_map)
		let modified_colours[hlgroup] = {}

		if has_key(standard_field_colour_map[hlgroup], 'Link')
			" This is a link entry: just copy across
			let modified_colours[hlgroup] = standard_field_colour_map[hlgroup]
			continue
		endif

		for field in keys(standard_field_colour_map[hlgroup])
			if s:all_fields[field] == 'Style'
				" Don't modify style hints
				let modified_colours[hlgroup][field] = standard_field_colour_map[hlgroup][field]
				continue
			elseif standard_field_colour_map[hlgroup][field] == 'NONE'
				" Don't modify those specified as NONE
				let modified_colours[hlgroup][field] = 'NONE'
				continue
			elseif hlgroup == 'Normal'
				" Handle customised colours
				if s:all_fields[field] != 'Style' && has_key(a:ColourScheme['Colours'], standard_field_colour_map[hlgroup][field])
					let standard_field_colour_map[hlgroup][field] = a:ColourScheme['Colours']
				endif
				" Do a complete colour invert on normal
				let std_colour = EasyColour#Translate#GetHexColour(standard_field_colour_map[hlgroup][field])
				let modified_colours[hlgroup][field] = EasyColour#Shade#Invert(std_colour)
			else
				" Handle customised colours
				if s:all_fields[field] != 'Style' && has_key(a:ColourScheme['Colours'], standard_field_colour_map[hlgroup][field])
					let standard_field_colour_map[hlgroup][field] = a:ColourScheme['Colours']
				endif
				let std_colour = EasyColour#Translate#GetHexColour(standard_field_colour_map[hlgroup][field])
				" Modify the colour if it's too dark or too light
				if a:details == 'Dark'
					let modified_colour = EasyColour#Shade#LightBGToDarkBG(std_colour)
				elseif a:details == 'Light'
					let modified_colour = EasyColour#Shade#DarkBGToLightBG(std_colour)
				else
					echoerr "Parameter passed incorrectly: something's gone very wrong!"
				endif

				" Now have a look for any overrides
				let override_key = a:details . 'Override'
				if has_key(override_map, hlgroup) && has_key(override_map[hlgroup], field)
					let modified_colour = override_map[hlgroup][field]
					" Handle customised colours
					if s:all_fields[field] != 'Style' && has_key(a:ColourScheme['Colours'], modified_colour)
						let modified_colour = a:ColourScheme['Colours']
					endif
				endif

				if colour_map == 'None' || s:all_fields[field] == 'Style'
					let modified_colours[hlgroup][field] = modified_colour
				elseif modified_colours[hlgroup][field] == 'NONE'
					" Leave as is
				else
					let s:need_to_write_cache = 1
					let modified_colours[hlgroup][field] = 
								\ EasyColour#Translate#FindNearest(colour_map, modified_colour)
				endif
			endif
		endfor
	endfor
	return s:RunHighlighter(modified_colours)
endfunction
