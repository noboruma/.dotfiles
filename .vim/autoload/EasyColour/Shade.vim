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
	if &cp || (exists('g:loaded_EasyColourShade') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_EasyColourShade = 1

function! EasyColour#Shade#Invert(hex)
	let rgb = EasyColour#Translate#HexToRGB(a:hex)
	let new_rgb = [255-rgb[0], 255-rgb[1], 255-rgb[2]]
	return EasyColour#Translate#RGBToHex(new_rgb)
endfunction

function! EasyColour#Shade#LightBGToDarkBG(hex)
	let percentage = 1.30
	let lighten_below_here = 0x7f*3

	let rgb = EasyColour#Translate#HexToRGB(a:hex)
	let Red = rgb[0]
	let Green = rgb[1]
	let Blue = rgb[2]

	if (Red+Green+Blue) < lighten_below
		return a:hex
	endif

	let Red = Red*percentage/100
	let Green = Green*percentage/100
	let Blue = Blue*percentage/100

	if Red > 255
		let Red = 255
	endif
	if Green > 255
		let Green = 255
	endif
	if Blue > 255
		let Blue = 255
	endif

	return EasyColour#Translate#RGBToHex([Red,Green,Blue])
endfunction

function! EasyColour#Shade#DarkBGToLightBG(hex)
	let percentage = 70
	let darken_above_here = 0x7f*3

	let rgb = EasyColour#Translate#HexToRGB(a:hex)
	let Red = rgb[0]
	let Green = rgb[1]
	let Blue = rgb[2]

	if (Red+Green+Blue) < darken_above_here
		return a:hex
	endif

	let Red = Red*percentage/100
	let Green = Green*percentage/100
	let Blue = Blue*percentage/100

	return EasyColour#Translate#RGBToHex([Red,Green,Blue])
endfunction
