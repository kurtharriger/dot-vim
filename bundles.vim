set nocompatible               " be iMproved
filetype on
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" :'<,'>!sort -fi -t/ -k2
Bundle "FuzzyFinder"
Bundle "L9"
Bundle "Screen-vim---gnu-screentmux"
Bundle "corntrace/bufexplorer"
Bundle "sjl/gundo.vim"
Bundle "nanotech/jellybeans.vim"
Bundle "scrooloose/nerdtree"
Bundle "honza/snipmate-snippets"
Bundle "ervandew/supertab"
Bundle "tomtom/tlib_vim"
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "rson/vim-conque"
Bundle "tpope/vim-fugitive"
Bundle "garbas/vim-snipmate"
Bundle "int3/vim-taglist-plus"
Bundle "tpope/vim-unimpaired"
Bundle "vim-scripts/VimClojure"

filetype plugin indent on 


