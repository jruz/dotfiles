set nocompatible
set encoding=utf-8
set tabstop=2
set shiftwidth=2
set expandtab
let mapleader=","
set number
set signcolumn=yes
set autoread
set updatetime=1000
set splitbelow
set splitright
set lazyredraw
syntax on
filetype plugin indent on
set mouse=
set noshowmode
set laststatus=2
set backspace=indent,eol,start
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=longest:full,full
set hidden

set foldmethod=indent
set foldnestmax=4
set nofoldenable
set foldlevel=1

set clipboard=unnamedplus
if has('mac')
  set clipboard=unnamed
endif

augroup AutoRead
  autocmd!
  autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * if mode() != 'c' | checktime | endif
augroup END

augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

highlight ColorColumn ctermbg=magenta guibg=magenta
call matchadd('ColorColumn', '\%81v', 80)

highlight ExtraWhitespace ctermbg=red guibg=red
augroup TrailingWhitespace
  autocmd!
  autocmd BufWinEnter * if &buftype == '' | match ExtraWhitespace /\s\+$/ | endif
augroup END

command! Config :edit ~/.vimrc
command! -bang Wq :wq<bang>
command! -bang Wqa :wqa<bang>
command! -bang Qa :qa<bang>

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <A-T> :tabnew<CR>
nnoremap <A-[> :tabprev<CR>
nnoremap <A-]> :tabnext<CR>

inoremap <C-S> <Esc>:update<CR>gi
nnoremap <C-S> :update<CR>

nnoremap <C-z> u
inoremap <C-z> <C-o>u
nnoremap U <C-r>

nnoremap <C-t> :Lexplore<CR>

nnoremap yy "+yy
vnoremap y "+y
nnoremap p "+p
nnoremap P "+P
nnoremap D "+D
nnoremap dd "+dd
vnoremap d "+d

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
let g:netrw_altv = 1

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %l:%c
set statusline+=\ %p%%\

set termguicolors
set background=dark
colorscheme catppuccin_mocha
