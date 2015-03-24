set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"--------------- Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'mattn/emmet-vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-haml'
Plugin 'vim-ruby/vim-ruby'
Plugin 'gertjanreynaert/cobalt2-vim-theme'
Plugin 'digitaltoad/vim-jade'
Plugin 'Yggdroot/indentLine'
Plugin 'elzr/vim-json'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'airblade/vim-gitgutter'

call vundle#end()            " required
filetype plugin indent on    " required

set tabstop=2
set shiftwidth=2
set expandtab
let g:indentLine_char = '│'
let mapleader=","
colorscheme monokai
syntax enable
"set number

"--------------- NERDTree settings
" auto open if no file is especified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" sytart with bookmarks open
let NERDTreeShowBookmarks=1
" key for toggle 
map <C-n> :NERDTreeToggle<CR>
" close if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endifq


"--------------- Syntastic 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
