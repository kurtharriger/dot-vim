" Vim syntax file
" Language   : hdl (http://www1.idc.ac.il/tecs/)
" Maintainer : Brandon Vargo
" Last Change: January 16, 2012

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=50

" hdl keywords
syn keyword hdlKeyword CHIP IN OUT PARTS CLOCKED BUILTIN

" hdl constants
syn keyword hdlConstant false true

" built-in part names
syn keyword hdlParts Add16 ALU And And16 ARegister Bit DFF DMux DMux4Way DMux8Way DRegister FullAdder HalfAdder Inc16 Keyboard Mux Mux16 Mux4Way16 Mux8Way16 Nand Not Not16 Or Or16 Or8Way PC RAM16K RAM4K RAM512 RAM64 RAM8 Register ROM32K Screen Xor

" comments
syn match hdlTodo "[tT][oO][dD][oO]" contained
syn match hdlFixme "[fF][iI][xX][mM][eE]" contained
syn match hdlXxx "[xX][xX][xX]" contained
syn match hdlLineComment "//.*" contains=hdlTodo,hdlFixme,hdlXxx
syn region hdlComment start="/\*" end="\*/" contains=hdlTodo,hdlFixme,hdlXxx

" number literals
syn match hdlNumber "\<\d\+\>"

" map hdl groups to standard groups
hi link hdlKeyword Keyword
hi link hdlConstant Constant
hi link hdlParts Type
hi link hdlNumber Number
hi link hdlComment Comment
hi link hdlLineComment Comment
hi link hdlTodo Todo
hi link hdlFixme Todo
hi link hdlXxx Todo

let b:current_syntax = "hdl"
