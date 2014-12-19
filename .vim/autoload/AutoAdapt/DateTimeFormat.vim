" AutoAdapt/DateTimeFormat.vim: Date and time formats for the default rules.
"
" DEPENDENCIES:
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	02-Jul-2013	file creation

" Condense "Pacific Daylight Time" into "PDT".
let s:shortTimezone = substitute(strftime('%Z'), '\<\(\w\)\%(\w*\)\>\%(\W\+\|$\)', '\1', 'g')
function! AutoAdapt#DateTimeFormat#ShortTimezone()
    return s:shortTimezone
endfunction

function! AutoAdapt#DateTimeFormat#MonthFormat( month )
    return (a:month =~# "^...$" ? "%b" : "%B")
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
