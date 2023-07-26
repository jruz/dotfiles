
"--------------- Plug start
call plug#begin('~/.vim/plugged')

"--------------- Plugins
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'elmcast/elm-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'mattn/emmet-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'vim-airline/vim-airline'
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
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet'
let g:deoplete#enable_at_startup = 1
let g:neosnippet#enable_completed_snippet = 1
Plug 'quramy/tsuquyomi'
Plug 'jiangmiao/auto-pairs'
"Plug 'chrisbra/vim-diff-enhanced'

"--------------- Clojure
Plug 'tpope/vim-salve'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
Plug 'venantius/vim-cljfmt'

"--------------- Rust
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1

"--------------- Linting
Plug 'w0rp/ale'
Plug 'ngmy/vim-rubocop'

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
Plug 'towolf/vim-helm'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chr4/nginx.vim'
Plug 'leafgarland/typescript-vim'

"--------------- Color Schemes
"Plug 'rickharris/vim-monokai'
"Plug 'gertjanreynaert/cobalt2-vim-theme'
Plug 'DrSpatula/vim-buddy'

"--------------- Language Servers
let g:LanguageClient_serverCommands = {
  \ 'javascript': ['javascript-typescript-stdio'],
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

"--------------- Ale
let g:ale_lint_on_text_changed =  'normal'
let g:ale_linters = {'js': ['stylelint', 'eslint']}
let g:ale_linters = {'scss': ['stylelint']}
let g:ale_linter_aliases = {'js': 'css'}
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['eslint']
let g:ale_fixers['yml'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier', 'eslint']
let g:ale_fixers['css'] = ['prettier', 'stylelint']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['json'] = ['prettier']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['markdown'] = ['prettier']
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1

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

"--------------- Pasting indentation fix
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"--------------- DIFF settings
hi DiffDelete ctermbg=none
hi DiffAdd ctermbg=none
hi DiffChange ctermbg=none
