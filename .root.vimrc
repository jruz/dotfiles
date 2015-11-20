set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"--------------- Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-endwise'
Plugin 'Yggdroot/indentLine'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'd11wtq/ctrlp_bdelete.vim'

"--------------- Syntax highlighting
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-haml'
Plugin 'digitaltoad/vim-jade'
Plugin 'elzr/vim-json'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'vim-scripts/nginx.vim'

"--------------- Color Schemes
Plugin 'rickharris/vim-monokai'
Plugin 'gertjanreynaert/cobalt2-vim-theme'
Plugin 'DrSpatula/vim-buddy'

call vundle#end()            " required
filetype plugin indent on    " required

set tabstop=2
set shiftwidth=2
set expandtab
let g:indentLine_char = '│'
let mapleader=","
syntax enable               " enable syntax highlighting
set number                  " show line numbers
set autoread                " auto refresh files if modified outside
set splitbelow              " open new splits below
set splitright              " open new splits right
set lazyredraw              " speed up tweak

"--------------- Status line
set laststatus=2                               " always display status line
set statusline+=%f
set statusline+=%=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%m
set statusline+=[%{strlen(&fenc)?&fenc:&enc}\| " encoding
set statusline+=%{&fileformat}]                " file format
hi statusline ctermbg=3

"--------------- Hard mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"--------------- split navigation with ctrl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"--------------- Enable mouse
set ttyfast
set mouse=a
set ttymouse=xterm2

"--------------- Active Theme
colorscheme buddy

"--------------- NERDTree settings
"-- auto open if no file is especified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"-- sytart with bookmarks open
"let NERDTreeShowBookmarks=1
"-- key for toggle
map <C-n> :NERDTreeToggle<CR>
"-- close if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endifq
"-- ignore folders
let g:NERDTreeIgnore=['node_modules$[[dir]]']
let NERDTreeStatusline = 0

"--------------- Folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"--------------- Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_loc_list_height=4
let g:syntastic_aggregate_errors = 1
let g:syntastic_haml_checkers = ['haml_lint']

"--------------- CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/a/*,*/node_modules/*,*/spec/cov/*
call ctrlp_bdelete#init()
"let g:ctrlp_show_hidden = 1  " find hidden files

"--------------- change cursor between modes on tmux
"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"--------------- change cursor between modes on linux
"let &t_SI = "\<Esc>[6 q"
"let &t_EI = "\<Esc>[2 q"

"--------------- keymappings
imap <C-w> <esc><C-w>

"--------------- Cursorline only on active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
