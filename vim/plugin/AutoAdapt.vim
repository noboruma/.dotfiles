" AutoAdapt.vim: Automatically adapt timestamps, copyright notices, etc.
"
" DEPENDENCIES:
"   - AutoAdapt.vim autoload script
"   - AutoAdapt/DateTimeFormat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/plugin.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.007	07-Aug-2013	CHG: Return both status and list of
"				applicable rule names.
"				ENH: Implement :Adapt command to manually
"				trigger the adaptation (or override a configured
"				predicate disallowing it).
"				ENH: Allow overriding predicate with
"				:AutoAdapt! command.
"   1.10.006	06-Aug-2013	Pass filespec to AutoAdapt#Trigger().
"   1.10.005	05-Aug-2013	ENH: Allow to disable / limit automatic
"				adaptation via g:AutoAdapt_FilePattern
"				configuration.
"				ENH: Add :AutoAdapt command to opt-in to
"				automatic adaptation when it's either not
"				enabled for the current buffer, or was turned
"				off via :NoAutoAdapt.
"   1.00.004	04-Jul-2013	Add rule.name descriptions.
"	003	03-Jul-2013	Avoid modifying Last Changed lines with the
"				current date. Use new "patternexpr" attribute
"				to avoid a match (/\@!/) with the current date.
"				Allow disabling via :NoAutoAdapt command.
"	002	02-Jul-2013	Extend default rules for common formats seen in
"				$VIMRUNTIME/syntax/*.vim.
"	001	01-Jul-2013	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_AutoAdapt') || (v:version < 700)
    finish
endif
let g:loaded_AutoAdapt = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:AutoAdapt_FilePattern')
    let g:AutoAdapt_FilePattern = '*'
endif

let s:lastChangePattern = '\v\C%(<%(Last%(Changed?| [cC]hanged?| modified)|Modified)\s*:\s+)\zs'
if ! exists('g:AutoAdapt_Rules')
    let g:AutoAdapt_Rules = [
    \   {
    \       'name': 'Copyright notice',
    \       'patternexpr': '''\c\<Copyright:\?\%(\s\+\%((C)\|&copy;\|\%xa9\)\)\?\s\+\zs\(\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\%(\ze\k\@![^-]\|\(-\%('' . strftime("%Y") . ''\)\@!\d\{4}\)\>\)''',
    \       'replacement': '\=submatch(1) . "-" . strftime("%Y")'
    \   },
    \   {
    \       'name': 'Last Change full timestamp 12h',
    \       'pattern': s:lastChangePattern . '\a{3}(,?) \d{1,2} \a{3} \d{4} \d{2}:\d{2}:\d{2} [AP]M \u+',
    \       'replacement': '\=strftime("%a" . submatch(1) . " %d %b %Y %I:%M:%S %p ") . ' . string(AutoAdapt#DateTimeFormat#ShortTimezone())
    \   },
    \   {
    \       'name': 'Last Change full timestamp 24h day-month-year time',
    \       'pattern': s:lastChangePattern . '\a{3}(,?) \d{1,2} \a{3} \d{4} \d{2}:\d{2}:\d{2} %([AP]M)@!\u+',
    \       'replacement': '\=strftime("%a" . submatch(1) . " %d %b %Y %H:%M:%S ") . ' . string(AutoAdapt#DateTimeFormat#ShortTimezone())
    \   },
    \   {
    \       'name': 'Last Change full timestamp 24h month-day time year',
    \       'pattern': s:lastChangePattern . '\a{3}(,?) \a{3} \d{1,2} \d{2}:\d{2}:\d{2} \u+ \d{4}',
    \       'replacement': '\=strftime("%a" . submatch(1) . " %b %d %H:%M:%S ") . ' . string(AutoAdapt#DateTimeFormat#ShortTimezone()) . '. " " . strftime("%Y")'
    \   },
    \   {
    \       'name': 'Last Change date year-month-day',
    \       'patternexpr': string(s:lastChangePattern) . '. ''%('' . strftime("%Y[- ]%%(%b|%B)[- ]%d") . '')@!\d{4}([- ])(\a{2,16})\1\d{1,2}''',
    \       'replacement': '\=tr(strftime("%Y " . AutoAdapt#DateTimeFormat#MonthFormat(submatch(2)) . " %d"), " ", submatch(1))'
    \   },
    \   {
    \       'name': 'Last Change date year-mm-day',
    \       'patternexpr': string(s:lastChangePattern) . '. ''%('' . strftime("%Y[- /]%m[- /]%d") . '')@!\d{4}([- /])(0\d|1[012])\1\d{1,2}''',
    \       'replacement': '\=tr(strftime("%Y %m %d"), " ", submatch(1))'
    \   },
    \   {
    \       'name': 'Last Change date day-month-year',
    \       'patternexpr': string(s:lastChangePattern) . '. ''%('' . strftime("%d[- ]%%(%b|%B)[- ]%Y") . '')@!\d{1,2}([- ])(\a{2,16})\1\d{4}''',
    \       'replacement': '\=tr(strftime("%d " . AutoAdapt#DateTimeFormat#MonthFormat(submatch(2)) . " %Y"), " ", submatch(1))'
    \   },
    \   {
    \       'name': 'Last Change date month day, year',
    \       'patternexpr': string(s:lastChangePattern) . '. ''%('' . strftime("%%(%b|%B) %d, %Y") . '')@!(\a{2,16}) \d{1,2}, \d{4}''',
    \       'replacement': '\=strftime(AutoAdapt#DateTimeFormat#MonthFormat(submatch(1)) . " %d, %Y")'
    \   },
    \]
endif

if ! exists('g:AutoAdapt_FirstLines')
    let g:AutoAdapt_FirstLines = 25
endif
if ! exists('g:AutoAdapt_LastLines')
    let g:AutoAdapt_LastLines = 10
endif


"- commands --------------------------------------------------------------------

function! s:NoAutoAdapt()
    if exists('#AutoAdapt#BufWritePre#<buffer>')
	autocmd! AutoAdapt BufWritePre,FileWritePre <buffer>
    else
	let b:AutoAdapt = 0
    endif
endfunction
command! -bar NoAutoAdapt call <SID>NoAutoAdapt()

function! s:AutoAdapt( isOverride )
    if a:isOverride && ! empty(ingo#plugin#setting#GetBufferLocal('AutoAdapt_Predicate', ''))
	let b:AutoAdapt_Predicate = function('AutoAdapt#DummyPredicate')
    endif

    if exists('b:AutoAdapt')
	if ! b:AutoAdapt
	    unlet b:AutoAdapt
	endif
    else
	" To avoid installing the buffer-local autocmd in addition to the global
	" one when using :AutoAdapt on a buffer where the global trigger is
	" active (but no auto adapting took place yet, so b:AutoAdapt hasn't yet
	" been set), trigger our custom user event to check whether the global
	" g:AutoAdapt_FilePattern applies, and only define the buffer-local
	" autocmd if it doesn't.
	if exists('#AutoAdapt#User')
	    if v:version == 703 && has('patch438') || v:version > 703
		doautocmd <nomodeline> AutoAdapt User
	    else
		doautocmd              AutoAdapt User
	    endif
	endif
	if exists('b:AutoAdapt')
	    " The global trigger covers this buffer.
	    unlet b:AutoAdapt
	else
	    augroup AutoAdapt
		autocmd! BufWritePre,FileWritePre <buffer> if ! AutoAdapt#Trigger(expand('<afile>'), ingo#plugin#setting#GetBufferLocal('AutoAdapt_Rules'))[0] | call ingo#msg#ErrorMsg(ingo#err#Get()) | endif
	    augroup END
	endif
    endif
endfunction
command! -bar -bang AutoAdapt call <SID>AutoAdapt(<bang>0)

command! -bar -bang Adapt if ! AutoAdapt#Adapt(<bang>0) | echoerr ingo#err#Get() | endif


"- autocmds --------------------------------------------------------------------

if ! empty(g:AutoAdapt_FilePattern)
    augroup AutoAdapt
	autocmd!
	execute 'autocmd BufWritePre,FileWritePre' g:AutoAdapt_FilePattern 'if ! AutoAdapt#Trigger(expand("<afile>"), ingo#plugin#setting#GetBufferLocal("AutoAdapt_Rules"))[0] | call ingo#msg#ErrorMsg(ingo#err#Get()) | endif'
	execute 'autocmd User' g:AutoAdapt_FilePattern 'let b:AutoAdapt = -1'
    augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
