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
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'morhetz/gruvbox'
Plugin 'Yggdroot/indentLine'
Plugin 'calviken/vim-gdscript3'
Plugin 'tpope/vim-fugitive'
Plugin 'dense-analysis/ale'

Plugin 'junegunn/goyo.vim'

"Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'airblade/vim-gitgutter'
"Plugin 'majutsushi/tagbar'
"Plugin 'vim-scripts/CSApprox'
"Plugin 'sheerun/vim-polyglot'
"Plugin 'tpope/vim-rhubarb'
call vundle#end()
filetype plugin indent on

syntax on
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set ruler
set cmdheight=2 "do I need it?
set ttyfast
set so=999
set modeline " # vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
set ts=8 et sw=4 sts=4
let g:indentLine_char = '┊'
"set list lcs=tab:\┆\ 
set showcmd
set matchpairs+=<:>
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
set encoding=utf-8

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

let mapleader=','

map <F2> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

map <F3> :NERDTreeToggle<CR>

nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>

if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

"noremap YY "+y<CR>
"noremap <leader>p "+gP<CR>
"noremap XX "+x<CR>

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

"nmap <M-j> mz:m+<cr>`z
"nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

":call extend(g:ale_linters, {
    "\'python': ['flake8'],})

let python_highlight_all = 1

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


if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline_left_sep          = '▶'
    let g:airline_left_alt_sep      = '»'
    let g:airline_right_sep         = '◀'
    let g:airline_right_alt_sep     = '«'
    let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
    let g:airline#extensions#readonly#symbol   = '⊘'
    let g:airline#extensions#linecolumn#prefix = '¶'
    let g:airline#extensions#paste#symbol      = 'ρ'
    let g:airline_symbols.linenr    = '␊'
    let g:airline_symbols.branch    = '⎇'
    let g:airline_symbols.paste     = 'ρ'
    let g:airline_symbols.paste     = 'Þ'
    let g:airline_symbols.paste     = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
else
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''

    " powerline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
endif

