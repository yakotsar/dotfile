set nocompatible	" be iMproved, required
filetype off		" required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'	" Project and file navigation
Plugin 'vim-airline/vim-airline'
Plugin 'powerline/powerline-fonts'
Plugin 'morhetz/gruvbox'
call vundle#end()
filetype plugin indent on

syntax on

set background=dark
color gruvbox
let g:airline_powerline_fonts = 1

set nu

set laststatus=2

set tw=0		" textwidth - 0, to stop automatic wrapping

set belloff=all

set nobackup
set nowritebackup
set noswapfile

map <F2> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
map <F3> :NERDTreeToggle<CR>
nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78
