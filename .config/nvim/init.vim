"--------------- Plugged init
call plug#begin('~/.config/nvim/plugged')

"--------------- Plugins
Plug 'kien/ctrlp.vim'
Plug 'mattn/emmet-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-endwise'
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'
Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'ngmy/vim-rubocop'

"--------------- Syntax highlighting
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-haml'
Plug 'digitaltoad/vim-jade'
Plug 'elzr/vim-json'
Plug 'jelera/vim-javascript-syntax'
Plug 'vim-scripts/nginx.vim'
Plug 'chase/vim-ansible-yaml'
Plug 'hallison/vim-ruby-sinatra'
Plug 'smancill/conky-syntax.vim'

"--------------- Color Schemes
Plug 'rickharris/vim-monokai'
Plug 'gertjanreynaert/cobalt2-vim-theme'
Plug 'DrSpatula/vim-buddy'

call plug#end()
"--------------- Plugged end

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
"set ttyfast
"set mouse=a
"set ttymouse=xterm2

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
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

"--------------- keymappings
imap <C-w> <esc><C-w>

"--------------- Cursorline only on active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
