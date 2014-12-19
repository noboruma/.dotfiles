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
	if &cp || (exists('g:loaded_EasyColourTranslate') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_EasyColourTranslate = 1

let s:RGBMap = {}
let s:loaded_rgb_map = 0
let s:loaded_colour_cache = 0
let s:calculated_available_colours = 0

let s:plugin_paths = split(globpath(&rtp, 'autoload/EasyColour/Translate.vim'), '\n')
if len(s:plugin_paths) == 1
	let s:plugin_path = fnamemodify(s:plugin_paths[0], ':p:h:h:h')
elseif len(s:plugin_paths) == 0
	echoerr "Cannot find Translate.vim"
else
	echoerr "Multiple plugin installs found: something has gone wrong!"
endif
let s:cache_file = s:plugin_path . '/easycolour_cache.txt'

" 88 Colour and 256 Colour terminals are calculated on the fly

" 8/16 Colours taken from /etc/X11/app-defaults/XTerm-color
let s:available_colours = 
			\ {
			\     'CT8': 
			\         [
			\             'black',
			\             'red3',
			\             'green3',
			\             'yellow3',
			\             'blue2',
			\             'magenta3',
			\             'cyan3',
			\             'grey90',
			\         ],
			\     'CT16':
			\         [
			\             'black',
			\             'red3',
			\             'green3',
			\             'yellow3',
			\             'blue2',
			\             'magenta3',
			\             'cyan3',
			\             'grey90',
			\             'grey50',
			\             'red',
			\             'green',
			\             'yellow',
			\             '#5C5CFF',
			\             'magenta',
			\             'cyan',
			\             'white',
			\         ],
			\ }

" Colours that might not be in RGB.txt: map to existing colour
let s:missing_colour_map = {
			\ 'darkyellow': 'brown'
			\ }

let s:available_rgb_colours = {}

function! s:CalculateAvailableRGBColours()
	if ! s:loaded_rgb_map
		call s:LoadRGBMap()
	endif
	for k in ['CT8', 'CT16']
		let s:available_rgb_colours[k] = {}
		for colour in s:available_colours[k]
			let colour_key = tolower(colour)
			if colour_key =~ '^#\x\{6}$'
				let std_rgb_colour = [str2nr(colour_key[1:2], 16), str2nr(colour_key[3:4], 16), str2nr(colour_key[5:6], 16)]
			elseif has_key(s:RGBMap, colour_key)
				let std_rgb_colour = s:RGBMap[colour_key]
			elseif has_key(s:missing_colour_map, colour_key)
				let std_rgb_colour = s:RGBMap[s:missing_colour_map[colour_key]]
			else
				echoerr "Unrecognised standard colour: '" . colour . "'"
			endif
			let s:available_rgb_colours[k][colour] = std_rgb_colour
		endfor
	endfor

	let s:available_rgb_colours['CT256'] = {}

	" 88/256 Colour Table consists of 16 colours as CT16,
	" a cube of 6x6x6 colours and then a selection
	" of greys.
	for c in range(len(s:available_colours['CT16']))
		let s:available_rgb_colours['CT256'][c] = s:available_rgb_colours['CT16'][s:available_colours['CT16'][c]]
	endfor

	" Handle the colour cube - (colours 16-231)
	for r in range(6)
		for g in range(6)
			for b in range(6)
				let colour_num = 16 + (r*36) + (g*6) + b
				let cv = []
				for x in [r,g,b]
					if x > 0
						let xv = (x*40) + 55
					else
						let xv = 0
					endif
					let cv += [xv]
				endfor
				let s:available_rgb_colours['CT256'][colour_num] = cv
			endfor
		endfor
	endfor

	for grey in range(24)
		let level = (grey*10) + 8
		let s:available_rgb_colours['CT256'][232+grey] = [level,level,level]
	endfor
	let s:calculated_available_colours = 1
endfunction

function! s:LoadRGBMap()
	let rgb_files = split(globpath(&rtp, 'rgb.txt'),"\n")
	if len(rgb_files) < 1
		echoerr "Could not find rgb.txt"
	endif
	let s:RGBMap = {}
	for rgb_file in rgb_files
		let entries = readfile(rgb_file)
		for entry in entries
			if entry[0] == '!'
				continue
			endif
			" Remove leading and trailing whitespace and sort out formatting:
			let entry = substitute(entry, '^\s*\(\d\+\)\s\+\(\d\+\)\s\+\(\d\+\)\s\+\(.\{-}\)\s*$', '\1 \2 \3\t\4', '')
			" Split on tabs to separate numbers and name
			let parts = split(entry, '\t\+')
			let numbers = split(parts[0], '\s\+')
			if len(numbers) != 3
				echoerr "Wrong length in number split: '" . entry . "' (" . parts[0] . ")"
			endif
			let name = substitute(tolower(parts[1]), '\s\+', '', 'g')

			let colour = [str2nr(numbers[0]), str2nr(numbers[1]), str2nr(numbers[2])]
			let s:RGBMap[name] = colour
		endfor
	endfor
	let s:loaded_rgb_map = 1
endfunction

function! s:LoadColourCache()
	let s:ColourCache = {}
	let s:loaded_colour_cache = 1
	if ! filereadable(s:cache_file)
		return
	endif
	let mainkey = 'NO_KEY_FOUND'
	for line in readfile(s:cache_file)
		if line[0] == '\t' && mainkey != 'NO_KEY_FOUND'
			let parts = split(line[1:], ':')
			let s:ColourCache[mainkey][parts[0]] = parts[1]
		elseif len(line) > 0
			let mainkey = line
			if ! has_key(s:ColourCache, mainkey)
				let s:ColourCache[mainkey] = {}
			endif
		endif
	endfor
endfunction

function! EasyColour#Translate#WriteColourCache()
	let lines = []
	for key in keys(s:ColourCache)
		let lines += [key]
		for subkey in keys(s:ColourCache[key])
			let lines += ["\t" . subkey . ':' . s:ColourCache[key][subkey]]
		endfor
	endfor
	call writefile(lines, s:cache_file)
endfunction

function! EasyColour#Translate#HexToRGB(hex)
	let rgbSplitter = '^#\(\x\{2}\)\(\x\{2}\)\(\x\{2}\)$'
	let matches = matchlist(a:hex, rgbSplitter)
	return [str2nr(matches[1],16),str2nr(matches[2],16),str2nr(matches[3],16)]
endfunction

function! EasyColour#Translate#RGBToHex(rgb)
	return printf('#%02X%02X%02X', a:rgb[0],a:rgb[1],a:rgb[2])
endfunction


function! EasyColour#Translate#GetHexColour(colour)
	if ! s:loaded_rgb_map
		call s:LoadRGBMap()
	endif
	let colour_name = tolower(a:colour)
	if colour_name =~ '^#\x\{6}$'
		return colour_name
	elseif has_key(s:RGBMap, colour_name)
		return EasyColour#Translate#RGBToHex(s:RGBMap[colour_name])
	elseif has_key(s:missing_colour_map, colour_name)
		return EasyColour#Translate#RGBToHex(s:RGBMap[s:missing_colour_map[colour_name]])
	else
		echoerr "Unrecognised colour (GetHexColour): '" . a:colour . "'"
	endif
endfunction

function! EasyColour#Translate#FindNearest(subset, colour)
	if ! s:loaded_colour_cache
		call s:LoadColourCache()
	endif

	if has_key(s:ColourCache, a:subset)
		if has_key(s:ColourCache[a:subset], a:colour)
			return s:ColourCache[a:subset][a:colour]
		endif
	else
		let s:ColourCache[a:subset] = {}
	endif

	if ! s:calculated_available_colours
		call s:CalculateAvailableRGBColours()
	endif

	if ! has_key(s:available_rgb_colours, a:subset)
		echoerr "Unrecognised subset: " . a:subset
	endif

	if ! s:loaded_rgb_map
		call s:LoadRGBMap()
	endif

	let colour_key = tolower(a:colour)
	if colour_key =~ '^#\x\{6}$'
		let req_rgb_colour = [str2nr(colour_key[1:2], 16), str2nr(colour_key[3:4], 16), str2nr(colour_key[5:6], 16)]
	elseif has_key(s:RGBMap, colour_key)
		let req_rgb_colour = s:RGBMap[colour_key]
	elseif has_key(s:missing_colour_map, colour_key)
		let req_rgb_colour = s:RGBMap[s:missing_colour_map[colour_key]]
	else
		echoerr "Unrecognised colour: '" . a:colour . "'"
	endif

	let min_distance = 0
	let closest_colour = ''
	for subset_colour in keys(s:available_rgb_colours[a:subset])
		let rgb_colour = s:available_rgb_colours[a:subset][subset_colour]

		" Now find the 'distance' to each colour
		let distance = s:ColourDistance(req_rgb_colour, rgb_colour)
		if closest_colour == '' || distance < min_distance
			let min_distance = distance
			let closest_colour = subset_colour
		endif
	endfor
	if index(['CT8','CT16'], a:subset) != -1
		let result = index(s:available_colours[a:subset], closest_colour)
	else
		let result =  closest_colour
	endif
	let s:ColourCache[a:subset][a:colour] = result
	return result
endfunction

function! s:ColourDistance(colour1, colour2)
	let xdiff = a:colour1[0] - a:colour2[0]
	let ydiff = a:colour1[1] - a:colour2[1]
	let zdiff = a:colour1[2] - a:colour2[2]

	let distance = sqrt((xdiff*xdiff)+(ydiff*ydiff)+(zdiff*zdiff))
	return distance
endfunction

" Debug functions:
function! EasyColour#Translate#PrintRGBMap()
	if ! s:loaded_rgb_map
		call s:LoadRGBMap()
	endif
	echo s:RGBMap
endfunction

function! EasyColour#Translate#PrintColours()
	if ! s:loaded_rgb_map
		call s:LoadRGBMap()
	endif
	call s:CalculateAvailableRGBColours()

	echo len(keys(s:available_rgb_colours['CT256']))
	echo s:available_rgb_colours['CT256']
endfunction
