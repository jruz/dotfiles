"--------------- Plug start
call plug#begin('~/.vim/plugged')

"--------------- Plugins
Plug 'kien/ctrlp.vim'
Plug 'mattn/emmet-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-endwise'
Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'rking/ag.vim'
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'
Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'elmcast/elm-vim'
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }
Plug 'eraserhd/parinfer-rust', {
  \ 'do': 'cargo build --release',
  \ }
"-- Deoplete
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'wokalski/autocomplete-flow'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet'
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_completed_snippet = 1

"--------------- Clojure
Plug 'tpope/vim-salve'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
Plug 'venantius/vim-cljfmt'

"--------------- Linting
"Plug 'vim-syntastic/syntastic'
"Plug 'neomake/neomake'
"Plug 'jaawerth/neomake-local-eslint-first'
"Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'w0rp/ale'
Plug 'ngmy/vim-rubocop'
Plug 'flowtype/vim-flow'

"--------------- Syntax highlighting
Plug 'ap/vim-css-color'
Plug 'chase/vim-ansible-yaml'
Plug 'digitaltoad/vim-jade'
Plug 'elzr/vim-json'
Plug 'hallison/vim-ruby-sinatra'
Plug 'lambdatoast/elm.vim'
Plug 'mboughaba/i3config.vim'
Plug 'smancill/conky-syntax.vim'
Plug 'tpope/vim-haml'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/nginx.vim'
Plug 'styled-components/vim-styled-components'
"Plug 'othree/yajs.vim'
"Plug 'pangloss/vim-javascript'
Plug 'jelera/vim-javascript-syntax'

"--------------- Color Schemes
"Plug 'rickharris/vim-monokai'
"Plug 'gertjanreynaert/cobalt2-vim-theme'
Plug 'DrSpatula/vim-buddy'

"--------------- Language Servers
let g:LanguageClient_serverCommands = {
  \ 'javascript': ['flow-language-server', '--stdio'],
  \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"--------------- Plug end
call plug#end()

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
filetype plugin indent on
set clipboard=unnamed
au BufNewFile,BufRead *.inky-haml set filetype=haml

"--------------- Relative line numbers
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber

"--------------- Status line
"set laststatus=2                               " always display status line
"set statusline+=%f
"set statusline+=%=
"set statusline+=%#warningmsg#
""set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"set statusline+=%m
"set statusline+=[%{strlen(&fenc)?&fenc:&enc}\| " encoding
"set statusline+=%{&fileformat}]                " file format
"hi statusline ctermbg=3

"--------------- VIM Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

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

"--------------- Omnicomplete
"set autochdir "for filename completion on same directory
"filetype plugin on
"set omnifunc=syntaxcomplete#Complete
"let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabContextDefaultCompletionType = "<C-X><C-U>"
""let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"autocmd FileType *
  "\ if &omnifunc != '' |
  "\   call SuperTabChain(&omnifunc, "<C-P>") |
  "\ endif
" omnifuncs
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
augroup end
" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

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
let g:NERDTreeIgnore=['node_modules$[[dir]]', 'nashorn_code_cache$[[dir]]']
let NERDTreeStatusline = 0

"--------------- Folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"--------------- Ale
let g:ale_lint_on_text_changed =  'normal'
let g:ale_linters = {'js': ['stylelint', 'eslint', 'flow-language-server']}
let g:ale_linters = {'scss': ['stylelint']}
let g:ale_linter_aliases = {'js': 'css'}
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier', 'eslint']
let g:ale_fixers['yml'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['markdown'] = ['prettier']
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1

"--------------- Flow
let g:flow#enable = 0
let g:flow#showquickfix = 0

"--------------- CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/a/*,*/node_modules/*,*/spec/cov/*,*/dist/*,*/public/*,*/sites/*/modules/*,*/elm-stuff/*,*/vendor/*
call ctrlp_bdelete#init()
let g:ctrlp_show_hidden = 1  " find hidden files

"--------------- change cursor between modes on tmux
"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"--------------- change cursor between modes on linux
"let &t_SI = "\<Esc>[6 q"
"let &t_SR = "\<Esc>[4 q"
"let &t_EI = "\<Esc>[2 q"

"--------------- keymappings
imap <C-w> <esc><C-w>

"--------------- Cursorline only on active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

"--------------- Line length marker
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 80)

"--------------- Clojure plugins
let g:clj_fmt_autosave = 0
let g:clojure_maxlines = 80
