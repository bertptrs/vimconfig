execute pathogen#infect()

filetype plugin indent on
filetype plugin on
syntax on
set ruler
set title
set number
set hlsearch
set incsearch
set ignorecase smartcase
set omnifunc=syntaxcomplete#Complete
set background=light

set tabstop=4 softtabstop=4 shiftwidth=4
set backspace=eol,indent,start

colorscheme molokai

" I have never intended to use the builtin help
map <F1> <Esc>
imap <F1> <Esc>


map <F5> :update<CR>:make<CR>
imap <F5> <Esc>:update<CR>:make<CR>

map <F7> :call SetExecutable()<CR>
imap <F7> <Esc>:call SetExecutable<CR>

"language specific syntastic configurtion
let g:syntastic_cpp_compiler="g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"

autocmd Filetype python setlocal expandtab
autocmd Filetype markdown setlocal textwidth=72

" Remove trailing whitespace, always.
autocmd BufWritePre * :%s/\s\+$//e

" Keep backup files etc out of the way
set undodir=~/.cache/vim/undo " vim will not create this directory.
set directory=~/.cache/vim/swap " vim will not create this directory.
set backupdir=~/.cache/vim/backup " vim will not create this directory.
set viminfo+=n~/.cache/vim/viminfo
