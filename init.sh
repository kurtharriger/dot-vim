#/bin/sh

[ ! -d bundle/vundle ] && git clone http://github.com/gmarik/vundle.git bundle/vundle
vim -u bundles.vim +BundleInstall +qall
