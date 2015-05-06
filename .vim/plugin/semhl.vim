" A special thanks goes out to John Leimon <jleimon@gmail.com>
" for his more complete C/C++ version,
" which served as a great basis for understanding
" regex matching in Vim


let g:semanticColors = { 0x00: '72d572', 0x01: 'c5e1a5', 0x02: 'e6ee9c', 0x03: 'fff59d', 0x04: 'ffe082', 0x05: 'ffcc80', 0x06: 'ffab91', 0x07: 'bcaaa4', 0x08: 'b0bec5', 0x09: 'ffa726', 0x0a: 'ff8a65', 0x0b: 'f9bdbb', 0x0c: 'f9bdbb', 0x0d: 'f8bbd0', 0x0e: 'e1bee7', 0x0f: 'd1c4e9', 0x10: 'ffe0b2', 0x11: 'c5cae9', 0x12: 'd0d9ff', 0x13: 'b3e5fc', 0x14: 'b2ebf2', 0x15: 'b2dfdb', 0x16: 'a3e9a4', 0x17: 'dcedc8' , 0x18: 'f0f4c3', 0x19: 'ffb74d' }
let g:semanticUseBackground = 0
let s:hasBuiltColors = 0

let s:blacklist = ['goto', 'break', 'return', 'continue', 'asm', 'case', 'default', 'if', 'else', 'switch', 'while', 'for', 'do', 'sizeof', '__asm__', 'typeof', '__real__', '__imag__', 'int', 'long', 'short', 'char', 'void', 'signed', 'unsigned', 'float', 'double', 'size_t', 'ssize_t', 'FILE', 'DIR', '_Bool', 'bool', '_Complex', 'complex', '_Imaginary', 'imaginary', 'int8_t', 'int16_t', 'int32_t', 'int64_t', 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'struct', 'union', 'enum', 'typedef', 'static', 'register', 'auto', 'volatile', 'extern', 'const', 'inline', '__attribute__', '__LINE__', '__FILE__', '__DATE__', '__TIME__', '__STDC__', '__PRETTY_FUNCTION__', 'public', 'private', 'protected', 'class', 'template', 'typename', 'namespace', 'using', 'try', 'catch', 'delete', 'new', 'undef']

command! SemanticHighlight call s:semHighlight()
command! SemanticHighlightRevert call s:disableHighlight()
command! SemanticHighlightToggle call s:toggleHighlight()
command! RebuildSemanticColors call s:buildColors()

function! s:semHighlight()
	if s:hasBuiltColors == 0
		call s:buildColors()
	endif

	let i = 0
	let buflen = line('$')
	let pattern = '\<[\$]*[a-zA-Z\_][a-zA-Z0-9\_]*\>'
	let cur_color = 0
	let colorLen = len(g:semanticColors)

	while buflen
		let curline = getline(buflen)
		let index = 0
		while 1
			let match = matchstr(curline, pattern, index)
			let match_index = match(curline, pattern, index)

			if (!empty(match))
				if (index(s:blacklist, match) == -1)
					execute 'syn keyword _semantic' . cur_color . " containedin=phpBracketInString,phpVarSelector,phpClExpressions,phpIdentifier " . match 
					let cur_color = (cur_color + 1) % colorLen
				endif

				let index += len(match) + 1
			else
				break
			endif
		endwhile
		let buflen -= 1
	endwhile
endfunction

function! s:buildColors()
	if (g:semanticUseBackground)
		let type = 'bg'
	else
		let type = 'fg'
	endif

	for key in keys(g:semanticColors)
		execute 'hi! def _semantic'.key.' gui' . type . '=#'.g:semanticColors[key] . ' cterm' . type . '=' . key
	endfor
	let s:hasBuiltColors = 1
endfunction

function! s:disableHighlight()
	for key in keys(g:semanticColors)
		execute 'syn clear _semantic'.key
	endfor
endfunction

function! s:toggleHighlight()
	if (exists("b:semanticOn") && b:semanticOn == 1)
		call s:disableHighlight()
		let b:semanticOn = 0
	else
		call s:semHighlight()
		let b:semanticOn = 1
	endif
endfunction

