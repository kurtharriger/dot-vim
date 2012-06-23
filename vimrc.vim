" bvargo's vimrc, based on the following:
" --------------------
"
" - the sample vimrc that comes with vim
" - the vimrc at http://www.stripey.com/vim/vimrc.html
 
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Put vim in secure mode, disabling autocmd, shell, and write commands that
" are in .vimrc, .exrc, and .gvimrc files in the local directory
set secure

" Allow local .vimrc, .exrc, and .gvimrc files to be executed
set exrc

" Disable modelines, so there are no security issues
set nomodeline

" Set the backup and temporary directories
set backupdir=~/.vim/backups
set directory=~/.vim/tmp
if v:version >= 703
   " undo save file directory
   set undodir="~/.vim/undo"
endif

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup      " keep a backup file
endif
set history=150   " keep 150 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands

if v:version >= 703
   " save undo trees
   set undofile
endif

" do not save if editing in /tmp/
au BufWritePre /tmp/* setlocal noundofile

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also, set the hlsearch preference
if &t_Co > 2 || has("gui_running")
  syntax on         " turn on the syntax highlighting!
  set nohlsearch    " do not highlight matches with the last used search pattern
  colorscheme delek " set the colorscheme
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  augroup END

else
  set autoindent     " always set autoindenting on
endif " has("autocmd")

" Load matchit (% to bounce from do to end, etc.)
" matchit.vim has been included in vim since version 6.0
runtime! macros/matchit.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File

" Set the file format type to unix, so all of the ^M characters are visible
set fileformats=unix

" Make sure the swap is synced every time we write to it - uses sync() instead
" of the default fsync() - any non empty value enables this feature
" set swapsync=sync

" The number of characters typed before doing an update of the swap file
set updatecount=10

" Nunber of milliseconds before doing an update
set updatetime=10000

" Read/write a .viminfo file, remember filemarks for 500 files and store 2000
" lines of registers
set viminfo='500,\"2000

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
 set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting

" Set the number of spaces a tab counts for to 3, defaults to 8
set tabstop=3
set shiftwidth=3

" Round indent to a multiple of 'shiftwidth'
set shiftround

" Uses spaces in place of a tab character
set expandtab

" Disable automatically formating text as it is typed (see next option)
set formatoptions-=t

" Automatically format comments at 78 characters
set textwidth=78

" Smart indent (overridden by cindent if it is on)
set smartindent

" show EOL whitespace
let c_space_errors=1
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

"
" Specific file types
"
augroup filetype
   " CMake files
   autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in runtime! indent/cmake.vim 
   autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in set filetype=cmake
   autocmd BufRead,BufNewFile *.ctest,*.ctest.in set filetype=cmake
   " Text Files
   "autocmd BufNewFile,BufRead *.txt set filetype=human
   " Recognize anything with a .ic extension (interactive-c) as being of type c
   autocmd BufNewFile,BufRead *.ic set filetype=c
   " Recognize .tpl files as html templates
   autocmd BufNewFile,BufRead *.tpl set filetype=html
   " Recognize anything with a .s extension as being of type mips
   "autocmd BufNewFile,BufRead *.s set filetype=mips
   " Recognize anything with a .s extension as being of type nasm
   autocmd BufNewFile,BufRead *.s set filetype=nasm
   " Recognize anything with a .pde extension of being type java (processing)
   autocmd BufNewFile,BufRead *.pde set filetype=java
   " HDL files for CSCI 410
   autocmd BufNewFile,BufRead *.hdl set filetype=hdl
   " Jack files for CSCI 410
   autocmd BufNewFile,BufRead *.jack set filetype=jack
augroup END

" In human-language files, automatically format everything at 72 chars:
"autocmd FileType human,text set formatoptions+=t textwidth=72

" Behave like a wordprocessor for text files
" Visually word wrap (on entire words, not characters), but only enter line
" breaks when the enter key is explicitely hit
autocmd FileType human,text,tex set formatoptions=l lbr wrap

" For C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" For actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" For Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" In Python, do not un-indent comments
autocmd FileType python inoremap # X#

" For CSS, also have things in braces indented:
autocmd FileType css set smartindent

" For HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" For both CSS and HTML, use genuine tab characters for indentation, to make
" files a few bytes smaller:
" autocmd FileType html,css set noexpandtab tabstop=3

" In makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
autocmd FileType make set noexpandtab shiftwidth=8

" For ruby, autoindent with two spaces, always expand tabs
autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et

" For git commit messages, wrap text at 78 characters
autocmd FileType gitcommit set textwidth=78

" For clojure, enable highlighting builtins and rainbow parenthesis
let vimclojure#HighlightBuiltins=1
let vimclojure#ParenRainbow=1

" For clojure, override the filetype (clojure) to lisp for ctags
let tlist_clojure_settings = 'lisp;f:function'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface

" Have the mouse enabled all the time
set mouse=a

" Disable line wraps
set nowrap

" Enable line numbres
"set number

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif

if v:version >= 703
   " Enable relative line numbers
   "set relativenumber

   " Display a colored bar at column 81
"   set colorcolumn=81
endif

" Always keep 2 lines on the top and bottom of the screen
set scrolloff=2

" Turn off error beep/flash
set visualbell t_vb=

" Turn off visual bell
set novisualbell

" Show a title in the console's title bar
set title
set titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)

" Set the status line and make it always visible
set laststatus=2
" identical to the ruler
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" some others
"set statusline=%<%f%=%([%{Tlist_Get_Tagname_By_Line()}]%)
"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
" statusline is filename file_info
"               <break>
"               [current_git_branch] [current_tag]
"               current_column current_line/total_lines(%line)
set statusline=%t%m%r%h%w%=%{fugitive#statusline()}\ %([%{Tlist_Get_Tagname_By_Line()}]%)\ %v\ %l/%L(%p%%)

" Smoother redrawing of the screen, uses more characters to draw (don't use on
" tty line)
set ttyfast

" Short messages
" set shortmess=atI

" Show matching brace briefely when closing a brace
set showmatch

" Set the fold column, so we can use the mouse to open and close folds
" set foldcolumn=2

" Set the maximum number of tabs (default: 10)
set tabpagemax=40

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search and replace

" Make pattern matching smart, match non-case-sensitive if the pattern has
" upper case characters, used for the following commands: / ? n N :g :s
" not used for: * # gd tag search, after * and # can use a / to use smartcase
" and recall from history
set ignorecase
set smartcase

" Do incremental searching, so we see the 'best match so far'
set incsearch

" Assume the /g flag on :s substitutions to replace all matches in a line:
" set gdefault

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spelling

" Try to avoid misspelling words in the first place -- have the insert mode
" <Ctrl>+N/<Ctrl>+P keys perform completion on partially-typed words by
" checking the Linux word list and the personal `Ispell' dictionary; sort out
" case sensibly (so that words at starts of sentences can still be completed
" with words that are in the dictionary all in lower case):
set dictionary+=~/.ispell_en
set dictionary+=~/.ispell_en.US
" default complete is .,w,b,u,t,i
" set complete=.,w,k
" current buffer, other windows, other loaded buffers, other unlloaded buffers
"   in buffer list, tags, dictionary, included files
set complete=.,w,b,u,t,k,i
set infercase

" Turn on spellcheck for text files
autocmd FileType human,text set spell spelllang=en_us
autocmd FileType tex set spell spelllang=en_us

" Correct my common typos without me even noticing them:
abbreviate teh the


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc

" Get a dialog when a command fails
" set confirm

" For debugging
" set verbose=9

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Moving Around

" Have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" Allow selection past the end of the line in visual block mode (though the
" selection will include the spaces)
:set virtualedit+=block

" Page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
" noremap <Space> <PageDown>
" noremap <BS> <PageUp>
" noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]

" Scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>
" [<Ins> by default is like i, and <Del> like x.]

" Use <F5> to show the undo tree
nnoremap <F5> :GundoToggle<CR>

" Use <F6> to cycle through split windows (and <Shift>+<F6> to cycle backwards,
" where possible):
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

" Use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]

" Have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" Have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" Have f9 and f10 be previous / next tab
nnoremap <F9> :tabp<CR>
nnoremap <F10> :tabn<CR>
nnoremap <C-\> :tabnew<CR>
inoremap <F9> <Esc>:tabp<CR>
inoremap <F10> <Esc>:tabn<CR>
inoremap <C-\> <Esc>:tabnew<CR>
vnoremap <F9> <Esc>:tabp<CR>
vnoremap <F10> <Esc>:tabn<CR>
vnoremap <C-\> <Esc>:tabnew<CR>

" q will rewrap the current paragraph
"map q gq}

" jk and kj works as escape (smash escape)
"inoremap jk <Esc>
"inoremap kj <Esc>

" Always display the tab bar
set showtabline=2

" FuzzyFinder
"map <C-p> :FufFile<CR>
" FuzzyFinder open with directory of current directory (not directory of
" buffer)
"nnoremap <C-p> :FufFile <C-r>=fnamemodify(getcwd(), ':p')<CR><CR> 
" FuzzyFinder open with directory of the current buffer
"nnoremap <C-p> :FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR> 
"inoremap <C-p> <Esc>:FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR> 
"vnoremap <C-p> <Esc>:FufFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR> 
" FuzzyFinder open with current tag under cursor
"nnoremap <C-p> :FufTag <C-r><C-w><CR>
"inoremap <C-p> <Esc>:FufTag <C-r><C-w><CR>
"vnoremap <C-p> <Esc>:FufTag <C-r><C-w><CR>
" FuzzyFinder tag
nnoremap <C-p> :FufTag<CR>
inoremap <C-p> <Esc>:FufTag<CR>
vnoremap <C-p> <Esc>:FufTag<CR>


" TagList
nnoremap <silent> <F8> :TlistToggle<CR>
inoremap <silent> <F8> <Esc>:TlistToggle<CR>
vnoremap <silent> <F8> <Esc>:TlistToggle<CR>
" Automatically open
"let Tlist_Auto_Open=1
" Automatically close the taglist window when selecting a file or tag
let Tlist_Close_On_Select=1
" Close vim when only the taglist window remains
let Tlist_Exit_OnlyWindow=1
" Only require one click to select
let Tlist_Use_SingleClick=1
" Always process files, even if the taglist window is not open
let Tlist_Process_File_Always=1
" Sorting order of tags (options are order and name)
let Tlist_Sort_Type='name'

" Split to the right of the window, instead of the left
let Tlist_Use_Right_Window=1

" Tag autocomplete
" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
"set tags+=~/.vim/tags/gl
"set tags+=~/.vim/tags/sdl
"set tags+=~/.vim/tags/qt4
set tags+=~/.vim/tags/sys
"set tags+=~/.vim/tags/boost_ublas
" build tags of your own project with CTRL+l
map <C-l> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Formatting

" Have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" Have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" Have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Toggles
"
" Keystrokes to toggle options are defined here.  They are all set to normal
" mode keystrokes beginning \t but some function keys (which won't work in all
" terminals) are also mapped.

" Have \tp ("toggle paste") toggle paste on/off and report the change, and
" where possible also have <F4> do this both in normal and insert mode:
nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>

" Have \tl ("toggle list") toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

" Have \th ("toggle highlight") toggle highlighting of search matches, and
" report the change:
nnoremap \th :set invhls hls?<CR>

" Have \tf ("toggle format") toggle the automatic insertion of line breaks
" during typing and report the change:
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
  \ endif <Bar> set fo?<CR>
"nmap <F7> \tf
"imap <F7> <C-O>\tf

" Have \tw ("toggle wrap") toggle wrapping of text
nnoremap \tw :set invwrap wrap?<CR>
nmap <F7> \tw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Insert Mode

" Allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Have <Tab> (and <Shift>+<Tab> where it works) change the level of
" indentation:
"inoremap <Tab> <C-T>
"inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Make and Quickfix

" F3 runs make
nmap <F3> :make<CR>

" with unimpaired.vim, [q = cprev, ]q = cnext, [Q = cfirst, ]Q = clast

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - For HTML Files

" there are other key mappings that it's useful to have for typing HTML
" character codes, but that are definitely not wanted in other files (unlike
" the above, which won't do any harm), so only map these when entering an HTML
" file and unmap them on leaving it:
autocmd BufEnter * if &filetype == "html" | call MapHTMLKeys() | endif

function! MapHTMLKeys(...)
" Sets up various insert mode key mappings suitable for typing HTML, and
" automatically removes them when switching to a non-HTML buffer

  " if no parameter, or a non-zero parameter, set up the mappings:
  if a:0 == 0 || a:1 != 0

    " Require two backslashes to get one:
    inoremap \\ \

    " Then use backslash followed by various symbols insert HTML characters:
    inoremap \& &amp;
    inoremap \< &lt;
    inoremap \> &gt;
    inoremap \. &middot;

    " em dash -- have \- always insert an em dash, and also have _ do it if
    " ever typed as a word on its own, but not in the middle of other words:
    inoremap \- &#8212;
    iabbrev _ &#8212;

    " Hard space with <Ctrl>+Space, and \<Space> for when that doesn't work:
    inoremap \<Space> &nbsp;
    imap <C-Space> \<Space>

    " Have the normal open and close single quote keys producing the character
    " codes that will produce nice curved quotes (and apostophes) on both Unix
    " and Windows:
    inoremap ` &#8216;
    inoremap ' &#8217;
    " Then provide the original functionality with preceding backslashes:
    inoremap \` `
    inoremap \' '

    " Curved double open and closed quotes:
    inoremap \: &#8220;
    inoremap \" &#8221;

    " When switching to a non-HTML buffer, automatically undo these mappings:
    autocmd! BufLeave * call MapHTMLKeys(0)

  " Parameter of zero, so want to unmap everything:
  else
    iunmap \\
    iunmap \&
    iunmap \<
    iunmap \>
    iunmap \-
    iunabbrev _
    iunmap \<Space>
    iunmap <C-Space>
    iunmap `
    iunmap '
    iunmap \`
    iunmap \'
    "iunmap \2
    iunmap \"

    " Once done, get rid of the autocmd that called this:
    autocmd! BufLeave *

  endif " test for mapping/unmapping

endfunction " MapHTMLKeys()

" -------------------------------

let vimfiles=$HOME . "/.vim"

" Settings for VimClojure
let vimclojureRoot = vimfiles."/bundle/vimclojure"
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = vimclojureRoot."/lib/ng"

" Start vimclojure nailgun server (uses screen.vim to manage lifetime)
nmap <silent> <Leader>sc :execute "ScreenShell lein vimclojure" <cr>
" Start a generic Clojure repl (uses screen.vim)
nmap <silent> <Leader>sC :execute "ScreenShell lein repl" <cr>

" ------------
let g:ScreenImpl = 'Tmux'

set clipboard=unnamed
set tabstop=4
set shiftwidth=4
set expandtab

call pathogen#infect()
