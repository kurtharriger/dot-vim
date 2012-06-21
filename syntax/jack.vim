" Vim syntax file
" Language   : Jack

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

" most jack keywords
syn keyword jackKeyword else for if new return this while function do let subroutine constructor method var static field

" boolean literals
syn keyword jackBoolean true false

" definitions
syn keyword jackDef def nextgroup=jackDefName skipwhite
syn keyword jackVal val nextgroup=jackValName skipwhite
syn keyword jackVar var nextgroup=jackVarName skipwhite
syn keyword jackClass class nextgroup=jackClassName skipwhite
syn match jackDefName "[^ =:;([]\+" contained nextgroup=jackDefSpecializer skipwhite
syn match jackValName "[^ =:;([]\+" contained
syn match jackVarName "[^ =:;([]\+" contained 
syn match jackClassName "[^ =:;(\[]\+" contained nextgroup=jackClassSpecializer skipwhite

" type constructor (actually anything with an uppercase letter)
syn match jackConstructor "\<[A-Z][_$a-zA-Z0-9]*\>" nextgroup=jackConstructorSpecializer
syn region jackConstructorSpecializer start="\[" end="\]" contained contains=jackConstructorSpecializer

" method call
syn match jackRoot "\<[a-zA-Z][_$a-zA-Z0-9]*\."me=e-1
syn match jackMethodCall "\.[a-z][_$a-zA-Z0-9]*"ms=s+1

" comments
syn match jackTodo "[tT][oO][dD][oO]" contained
syn match jackLineComment "//.*" contains=jackTodo
syn region jackComment start="/\*" end="\*/" contains=jackTodo
syn case ignore
syn include @jackHtml syntax/html.vim
unlet b:current_syntax
syn case match
syn region jackDocComment start="/\*\*" end="\*/" contains=jackDocTags,jackTodo,@jackHtml keepend
syn region jackDocTags start="{@\(link\|linkplain\|inherit[Dd]oc\|doc[rR]oot\|value\)" end="}" contained
syn match jackDocTags "@[a-z]\+" contained

syn match jackEmptyString "\"\""

" multi-line string literals
syn region jackMultiLineString start="\"\"\"" end="\"\"\"" contains=jackUnicode
syn match jackUnicode "\\u[0-9a-fA-F]\{4}" contained

" string literals with escapes
syn region jackString start="\"[^"]" skip="\\\"" end="\"" contains=jackStringEscape " TODO end \n or not?
syn match jackStringEscape "\\u[0-9a-fA-F]\{4}" contained
syn match jackStringEscape "\\[nrfvb\\\"]" contained

" symbol and character literals
syn match jackSymbol "'[_a-zA-Z0-9][_a-zA-Z0-9]*\>"
syn match jackChar "'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'"

" number literals
syn match jackNumber "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match jackNumber "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match jackNumber "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match jackNumber "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

" xml literals
syn match jackXmlTag "<[a-zA-Z]\_[^>]*/>" contains=jackXmlQuote,jackXmlEscape,jackXmlString
syn region jackXmlString start="\"" end="\"" contained
syn match jackXmlStart "<[a-zA-Z]\_[^>]*>" contained contains=jackXmlQuote,jackXmlEscape,jackXmlString
syn region jackXml start="<\([a-zA-Z]\_[^>]*\_[^/]\|[a-zA-Z]\)>" matchgroup=jackXmlStart end="</\_[^>]\+>" contains=jackXmlEscape,jackXmlQuote,jackXml,jackXmlStart,jackXmlComment
syn region jackXmlEscape matchgroup=jackXmlEscapeSpecial start="{" matchgroup=jackXmlEscapeSpecial end="}" contained contains=TOP
syn match jackXmlQuote "&[^;]\+;" contained
syn match jackXmlComment "<!--\_[^>]*-->" contained

syn sync fromstart

" map jack groups to standard groups
hi link jackKeyword Keyword
hi link jackPackage Include
hi link jackImport Include
hi link jackBoolean Boolean
hi link jackOperator Normal
hi link jackNumber Number
hi link jackEmptyString String
hi link jackString String
hi link jackChar String
hi link jackMultiLineString String
hi link jackStringEscape Special
hi link jackSymbol Special
hi link jackUnicode Special
hi link jackComment Comment
hi link jackLineComment Comment
hi link jackDocComment Comment
hi link jackDocTags Special
hi link jackTodo Todo
hi link jackType Type
hi link jackTypeSpecializer jackType
hi link jackXml String
hi link jackXmlTag Include
hi link jackXmlString String
hi link jackXmlStart Include
hi link jackXmlEscape Normal
hi link jackXmlEscapeSpecial Special
hi link jackXmlQuote Special
hi link jackXmlComment Comment
hi link jackDef Keyword
hi link jackVar Keyword
hi link jackVal Keyword
hi link jackClass Keyword
hi link jackObject Keyword
hi link jackTrait Keyword
hi link jackDefName Function
hi link jackDefSpecializer Function
hi link jackClassName Special
hi link jackClassSpecializer Special
hi link jackConstructor Special
hi link jackConstructorSpecializer jackConstructor

let b:current_syntax = "jack"

" you might like to put these lines in your .vimrc
"
" customize colors a little bit (should be a different file)
" hi jackNew gui=underline
" hi jackMethodCall gui=italic
" hi jackValName gui=underline
" hi jackVarName gui=underline
