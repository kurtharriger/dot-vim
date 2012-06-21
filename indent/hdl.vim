" Vim indent file
" Language   : hdl (http://www1.idc.ac.il/tecs/)
" Maintainer : Brandon Vargo
" Last Change: January 16, 2012

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" set the indent function that does the work
setlocal indentexpr=GetHdlIndent()

" set indent keys and the shift width
setlocal indentkeys=0{,0},0),!^F,<>>,<CR>
setlocal autoindent sw=3 et

" if the function already exists, then there is no need to redefine things
if exists("*GetHdlIndent")
  finish
endif

" count the number of unmatched parentheses in the given line
function! CountParens(line)
  let line = substitute(a:line, '"\(.\|\\"\)*"', '', 'g')
  let open = substitute(line, '[^(]', '', 'g')
  let close = substitute(line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

" get the line number for the previous line, skipping blank lines and comments
function! PreviousLineHdlNonBlankComment(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~ '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~ '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~ '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

" the actual indent function
function! GetHdlIndent()
  " if we are in the middle of a comment, then trust cindent
  if getline(v:lnum) =~ '^\s*\*'
    return cindent(v:lnum)
  endif

  " find a non-blank line above the current line
  let lnum = PreviousLineHdlNonBlankComment(v:lnum - 1)

  " if the start of the file was found, use zero indent
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  " add one shiftwidth after starts of a block or the parts list
  if prevline =~ '^\s*PARTS:\s*\(//.*\|/\*.*\)\=$'
        \ || prevline =~ '{\s*\(//.*\|/\*.*\)\=$'
    let ind = ind + &shiftwidth
  endif

  " indent if parenthesis are unbalanaced
  let c = CountParens(prevline)
  if c > 0
    let ind = ind + &shiftwidth
  elseif c < 0
    let ind = ind - &shiftwidth
  endif

  " unindent on a }
  let thisline = getline(v:lnum)
  if thisline =~ '^\s*}'
    let ind = ind - &shiftwidth
  endif

  " when a line starts with a }, try aligning it with the matching {
  if getline(v:lnum) =~ '^\s*}\s*\(//.*\|/\*.*\)\=$'
    call cursor(v:lnum, 1)
    silent normal %
    let lnum = line('.')
    if lnum < v:lnum
      let lnum = PreviousLineHdlNonBlankComment(lnum - 1)
      let ind = indent(lnum)
    endif
  endif

  return ind
endfunction
