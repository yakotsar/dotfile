if empty(glob('~/.vim/bundle/Vundle.vim'))
    if !executable("git")
        echoerr "You have to install git"
        execute "q!"
    endif
    echo "Installing Vundle..."
    echo ""
    silent exec "!git clone -q https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
    autocmd VimEnter * PluginInstall
endif


set nocompatible	" be iMproved, required
filetype off		" required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
"Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'morhetz/gruvbox'
Plugin 'Yggdroot/indentLine'
Plugin 'calviken/vim-gdscript3'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
"Plugin 'majutsushi/tagbar'
call vundle#end()
filetype plugin indent on

let mapleader=','
syntax on
set so=999
set modeline " # vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
set ts=8 et sw=4 sts=4
let g:indentLine_char = '┊'
"set list lcs=tab:\┆\ 

set background=dark
color gruvbox
let g:airline_powerline_fonts = 1
set nu
set laststatus=2

set title
set titleold="Terminal"
set titlestring=%F

if exists("*fugitive#statusline")
    set statusline+=%{fugitive#statusline()}
endif

"let g:airline_theme = 'powerlineish'
"let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#ale#enabled = 1
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tagbar#enabled = 1
"let g:airline_skip_empty_sections = 1

set tw=0		" textwidth - 0, to stop automatic wrapping

set belloff=all

set nobackup
set nowritebackup
set noswapfile

map <F2> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

map <F3> :NERDTreeToggle<CR>

nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>

nnoremap <silent> <leader>sh :terminal<CR>

nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew <CR>

noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

vmap < <gv
vmap > >gv

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]:
    " https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")
    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python3 " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your
    " code buffer is forced to a height of one line every time you run this
    " function.
    " However without this line the buffer starts off as a default
    " size and if you resize the buffer then it keeps that custom size after
    " repeated runs of this function.
    " But if you close the output buffer then it returns to using the default
    " size when its reccreated
    "execute 'resize' . line('$')
    
    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction
