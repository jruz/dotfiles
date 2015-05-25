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
Plugin 'Yggdroot/indentLine'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-surround'
Plugin 'ntpeters/vim-better-whitespace'

"--------------- Syntax highlighting
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-haml'
Plugin 'digitaltoad/vim-jade'
Plugin 'elzr/vim-json'

"--------------- Color Schemes
Plugin 'rickharris/vim-monokai'
Plugin 'gertjanreynaert/cobalt2-vim-theme'

call vundle#end()            " required
filetype plugin indent on    " required

set tabstop=2
set shiftwidth=2
set expandtab
let g:indentLine_char = '│'
let mapleader=","
syntax enable               " enable syntax highlighting
"set number                 " show line numbers
set autoread                " auto refresh files if modified outside

"--------------- Status line
set laststatus=2                               " always display status line
set statusline+=%f
set statusline+=%=
set statusline+=[%{strlen(&fenc)?&fenc:&enc}\| " encoding
set statusline+=%{&fileformat}]                " file format

"--------------- Enable mouse
"set ttyfast
set mouse=a
set ttymouse=xterm2

"--------------- Active Theme
colorscheme monokai

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
" ignore folders
let g:NERDTreeIgnore=['node_modules$[[dir]]']
let NERDTreeStatusline = 0

"--------------- Folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"--------------- Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_loc_list_height=4

"--------------- CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/a/*,*/node_modules/*,*/spec/cov/*
"let g:ctrlp_show_hidden = 1  " find hidden files

"--------------- change cursor between modes on tmux
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

"--------------- keymappings
imap <C-w> <esc><C-w>
