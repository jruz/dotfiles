set nocompatible

call plug#begin(stdpath('data') . '/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wting/gitsessions.vim'
Plug 'osyo-manga/vim-over'


"--------------- Themes
"Plug 'DrSpatula/vim-buddy'
"Plug 'joshdick/onedark.vim'
Plug 'dunckr/vim-monokai-soda'

call plug#end()

"--------------- Active Theme
colorscheme monokai-soda

"--------------- Settings
set tabstop=2
set shiftwidth=2
set expandtab
let g:indentLine_char = '│'
let mapleader=","
set number                  " show line numbers
set autoread                " auto refresh files if modified outside
set splitbelow              " open new splits below
set splitright              " open new splits right
set lazyredraw              " speed up tweak
syntax on                   " enable syntax highlighting

"--------------- Shortcuts
nnoremap <C-P> :Files<Enter>
nnoremap <C-B> :Buffers<Enter>

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

"--------------- Cursorline only on active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

"--------------- Line length marker
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 80)

"--------------- Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"--------------- VIM Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
