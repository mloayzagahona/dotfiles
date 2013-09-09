call pathogen#infect()

" Basic Settings {{{
syntax on
filetype on
compiler ruby

"sets shell title to correct thing
set title

" remove gui fancyness
if has("gui_running")
    set guioptions=-T

    " set default font
    set guifont=DejaVu\ Sans\ Mono\ 10
endif

" bump up command history
set history=1000

" does good stuff with buffers
set hidden

" keep a bit of context around current cursor position
set scrolloff=5

set backupdir=/tmp
set directory=/tmp

" make completion better
set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,.svn,*.jar,"help/**"

" minimum window height
set wmh=0

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" invisible characters
set listchars=trail:.,tab:>-,eol:$
set nolist

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.js :call DeleteTrailingWS()

" wombat theme
set t_Co=256
set background=dark
colorscheme wombat256mod

" ignore case in searches, except if you type a capital letter
set ignorecase
set smartcase
set nohlsearch
set incsearch

set go-=T " hide the toolbar by default
set nu " show line numbers
filetype plugin on " figure out filetype automatically
filetype indent on " indent based on filetype
set ruler " show ruler
set autoread " auto read updates to file from outside vim

" remove tabs for 2 spaces
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set cindent
set showmatch
set matchtime=1

" turn off annoying messages
set shortmess=atI

" ack integration
set grepprg=ack\ -a
set swb=newtab " switch buffer mode opens a new tab

" always show status line
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim
set laststatus=2
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" }}}

" Key mappings {{{
" map leader and localleader
let mapleader=","
let maplocalleader="\\"

nnoremap <leader>i :set list!<CR> " Toggle invisible chars

" easy to source / edit this file
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" taglist shortcuts
nnoremap <silent> <leader>T :TlistToggle<CR>

" Remap autocomplete to CTRL+SPACE
inoremap <C-space> <C-n>

" Remap alt-j alt-k to insert blank lines without going to insert mode
nnoremap <silent><D-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><D-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" rebuild ctags
nnoremap <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f<CR> 

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" move line down and up
nnoremap - ddp
nnoremap _ ddkp

" uppercase word in interactive mode
inoremap <c-u> <esc>vawU

" map jk to escape, very cool!
inoremap jk <esc>
" }}}"

" Vimscript file settings {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Abbreviations {{{

" common mistypes
iabbrev waht what
iabbrev taht that
"}}}"

