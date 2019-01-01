" AutoAdapt.vim: Automatically adapt timestamps, copyright notices, etc.
"
" DEPENDENCIES:
"   - ingo/actions.vim autoload script
"   - ingo/collection/unique.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/plugin/setting.vim autoload script
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.008	18-Nov-2013	Adapt to changed ingo#actions#EvaluateOrFunc()
"				interface in ingo-library 1.015.
"   1.10.007	07-Aug-2013	CHG: Return both status and list of
"				applicable rule names.
"				ENH: Implement :Adapt command to manually
"				trigger the adaptation (or override a configured
"				predicate disallowing it).
"				FIX: Properly clear b:AutoAdapt indicator when
"				no rules apply any more, or the predicate
"				disallows adaptation.
"   1.10.006	06-Aug-2013	Pass filespec to AutoAdapt#Trigger().
"				ENH: Allow to skip adaptation with
"				g:AutoAdapt_Predicate.
"   1.01.005	09-Jul-2013	Enable patternexpr Funcref to skip the rule
"				application by :throw AutoAdaptSkip.
"   1.00.004	08-Jul-2013	Don't clobber the search history.
"	003	03-Jul-2013	Add rule.patternexpr configuration attribute.
"				Allow disabling via b:AutoAdapt flag.
"				Switch default range to the config variables.
"				Avoid that the same substitution error is added
"				multiple times.
"	002	02-Jul-2013	Add rule.range configuration and default to
"				'modelines' line offset from start and end.
"	001	01-Jul-2013	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:StartAndEndRange( startOffset, endOffset )
    let l:ranges = []
    let l:lastStartLnum = min([line('$'), a:startOffset])
    if a:startOffset > 0
	call add(l:ranges, '1,' . l:lastStartLnum)
    endif

    let l:firstEndLnum = max([1, line('$') - a:endOffset + 1])
    let l:firstEndLnum = max([l:lastStartLnum + 1, l:firstEndLnum])
    if l:firstEndLnum <= line('$')
	call add(l:ranges, l:firstEndLnum . ',$')
    endif
    return l:ranges
endfunction
function! s:GetRanges( rule )
    if empty(get(a:rule, 'range', ''))
	return s:StartAndEndRange(
	\   ingo#plugin#setting#GetBufferLocal('AutoAdapt_FirstLines'),
	\   ingo#plugin#setting#GetBufferLocal('AutoAdapt_LastLines')
	\)
    elseif a:rule.range ==# 'modelines'
	return s:StartAndEndRange(&modelines, &modelines)
    else
	return [a:rule.range]
    endif
endfunction
function! AutoAdapt#Trigger( filespec, rules )
    if exists('b:AutoAdapt') && ! b:AutoAdapt
	return [2, []]
    endif

    unlet! b:AutoAdapt  " We're good to go; first clear any indication of a previous adaptation.
    if empty(a:rules) || ! &l:modifiable
	return [2, []]
    endif
    let l:Predicate = ingo#plugin#setting#GetBufferLocal('AutoAdapt_Predicate', '')
    if ! empty(l:Predicate)
	try
	    if ! call(l:Predicate, [a:filespec])
		return [3, []]
	    endif
	catch /^Vim\%((\a\+)\)\=:/
	    call ingo#err#SetVimException()
	    return [0, []]
	endtry
    endif

    let l:errors = []
    let l:save_view = winsaveview()
    let l:applicableRules = []
    let l:didSubstitute = 0
    for l:rule in a:rules
	try
	    if has_key(l:rule, 'patternexpr')
		let l:rule.pattern = ingo#actions#EvaluateOrFunc(l:rule.patternexpr, l:rule)
	    endif

	    let l:previousChangedtick = b:changedtick
	    let l:sep = get(l:rule, 'substitutionSeparator', '/')
	    for l:range in s:GetRanges(l:rule)
		silent execute printf('keepjumps %ssubstitute%s%s%s%s%sge',
		\   l:range,
		\   l:sep,
		\   l:rule.pattern,
		\   l:sep,
		\   l:rule.replacement,
		\   l:sep
		\)
		let l:didSubstitute = 1
	    endfor
	    if b:changedtick > l:previousChangedtick
		call add(l:applicableRules, get(l:rule, 'name', l:rule.pattern))
	    endif
	catch /^Vim\%((\a\+)\)\=:E/
	    call ingo#collections#unique#AddNew(l:errors, ingo#msg#MsgFromVimException())
	catch /^AutoAdaptSkip/
	    " The Funcref signals to have this rule skipped.
	catch
	    call ingo#collections#unique#AddNew(l:errors, v:exception)
	endtry
    endfor
    if l:didSubstitute
	call winrestview(l:save_view)
	call histdel('search', -1)
    endif

    if len(l:applicableRules) > 0
	" Indicate that the contents were indeed adapted.
	let b:AutoAdapt = len(l:applicableRules)
    else
	unlet! b:AutoAdapt
    endif

    if len(l:errors) > 0
	call ingo#err#Set(join(l:errors, "\n"))
	return [0, l:applicableRules]
    endif
    return [1, l:applicableRules]
endfunction

function! AutoAdapt#DummyPredicate( filespec )
    return 1
endfunction
function! AutoAdapt#Adapt( isOverride )
    let l:isNoAutoAdaptSuspended = 0
    if exists('b:AutoAdapt') && ! b:AutoAdapt
	" Temporarily suspend the :NoAutoAdapt flag to enable adaptation.
	let l:isNoAutoAdaptSuspended = 1
	unlet b:AutoAdapt
    endif
    let l:isOverridePredicate = 0
    if a:isOverride && ! empty(ingo#plugin#setting#GetBufferLocal('AutoAdapt_Predicate', ''))
	let l:isOverridePredicate = 1
	if exists('b:AutoAdapt_Predicate')
	    let l:Save_Predicate = b:AutoAdapt_Predicate
	endif
	let b:AutoAdapt_Predicate = function('AutoAdapt#DummyPredicate')
    endif

	let [l:status, l:applicableRules] = AutoAdapt#Trigger(expand('%'), ingo#plugin#setting#GetBufferLocal('AutoAdapt_Rules'))

    if l:isOverridePredicate
	if exists('l:Save_Predicate')
	    let b:AutoAdapt_Predicate = l:Save_Predicate
	else
	    unlet b:AutoAdapt_Predicate
	endif
    endif
    if l:isNoAutoAdaptSuspended
	let b:AutoAdapt = 0
    endif

    if l:status == 1
	echomsg 'Adapted' join(l:applicableRules, ', ')
    elseif l:status == 2
	if ! &l:modifiable
	    call ingo#err#Set("Cannot make changes, 'modifiable' is off")
	else
	    call ingo#err#Set('No rules defined')
	endif
	return 0
    elseif l:status == 3
	call ingo#err#Set('Adaptation disabled; (add ! to override)')
	return 0
    endif
    return l:status
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
