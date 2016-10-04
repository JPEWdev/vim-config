runtime bundle/vim-pathogen/autoload/pathogen.vim

execute pathogen#infect()

set nocompatible
set ruler
set showcmd
set incsearch
set autoindent
set softtabstop=0
set tabstop=4
set expandtab

set cursorline
set nowrap
set hidden

map <C-Tab> <Esc>:bn<CR>
map <C-S-Tab> <Esc>:bp<CR>
map <F3> <ESC>n
imap <F3> <ESC>ni
map <C-F4> <ESC>:bd<CR>

nnoremap <C-k> <C-w><Up>
nnoremap <C-j> <C-w><Down>
nnoremap <C-h> <C-w><Left>
nnoremap <C-l> <C-w><Right>

inoremap <C-U> <C-G>u<C-U>

if has('mouse')
  set mouse=a
endif

set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

map <C-\> :split<CR>:exec("tag ".expand("<cword>"))<CR>
map <F12> :buffers<BAR>
           \let i = input("Buffer number: ")<BAR>
           \execute "buffer " . i<CR>

if has('gui_running')
  set guifont=Hack\ 9
  set guioptions-=m "remove menu bar
  set guioptions-=T "remove toolbar
endif

syntax enable
set number
set background=dark
colorscheme solarized

au BufNewFile,BufRead wscript* set filetype=python

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

command! -nargs=+ Sgrep execute 'silent grep! <args>' | copen

set spell

let g:linuxsty_patterns = [ "/linux", "/kernel" ]


