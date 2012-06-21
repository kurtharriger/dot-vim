" Vim syntax file
" Language: Jack
" Maintainer: Joshua French
" Latest Revision: 29 March 2012


if exists("b:current_syntax")
	finish
endif

syn keyword variableDeclarations var static field
syn keyword constantValues true false null
syn keyword statements let do if else while return
syn keyword primitiveTypes int boolean char void
syn keyword programComponents class constructor method function

syn region comments start=/\/\// end=/\n/
syn region comments start=/\/\*/ end=/\*\//
syn region comments start=/\/\*\*/ end=/\*\//

hi def link variableDeclarations	Special
hi def link constantValues      	Constant
hi def link statements          	Statement
hi def link primitiveTypes      	Identifier
hi def link programComponents   	Type
hi def link comments             	Comment

let b:current_syntax = "jack"
