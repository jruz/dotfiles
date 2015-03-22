set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
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

call vundle#end()            " required
filetype plugin indent on    " required
set tabstop=2
set shiftwidth=2
set expandtab

let g:indentLine_char = '│'
let g:indentLine_color_term = 90
let mapleader=","

syntax enable
"set number
colorscheme monokai
