" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'git://git.openembedded.org/bitbake', { 'rtp': 'contrib/vim' }
Plug 'easymotion/vim-easymotion'
Plug 'JPEWdev/vim-linux-coding-style'
Plug 'ericbn/vim-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'rgarver/Kwbd.vim'
Plug 'JPEWdev/vim-esearch'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-markdown'
Plug 'igankevich/mesonic'
Plug 'tpope/vim-fugitive'
Plug 'stephpy/vim-yaml'
Plug 'rhysd/vim-clang-format'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'rust-lang/rust.vim'

call plug#end()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
"set autowriteall

set background=dark
if !has('gui_running')
    set termguicolors
endif
colorscheme solarized

set viminfo+=!      " Save CAPITOLIZED global variables

set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position in lower right corner all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

set autoindent      " autoindent
set autoread        " Automatically update files if changed outside of Vim
set number          " Show line numbers
set cursorline      " Highlight the current line
set nowrap          " Don't wrap lines at the edge of the screen

set tabstop=4       " Tabs are 4 spaces each
set expandtab       " Type spaces when the Tab key is pressed
set shiftwidth=4    " Indent 4 spaces
set smarttab        " Treat shiftwidth spaces as a 'virtual tab' on empty lines.
                    " i.e. one backspace press will remove shiftwidth spaces and
                    " one tab press will insert shiftwidth spaces
set shiftround      " Round shift operators '>' and '<' to a multiple of shiftwidth

set showtabline=2
set hidden

set wildmenu        " Show the completion menu
set wildmode=longest:full,full  " On the first Tab, complete to the longest string,
                                " then show match list. On the next tab, match
                                " complete the next match

set encoding=utf8   " Display files as UTF-8

set number
set relativenumber

set updatetime=500  " Update more frequently ms too keep git gutter snappy
set signcolumn=yes  " Always show sign column

set laststatus=2    "Always show status line
let g:airline#extensions#tabline#enabled = 1 " Show buffer list in airline
let g:airline_powerline_fonts = 1 " Use Powerline fonts
let g:airline_theme = 'dark' " Use the default airline theme. I like it better than solarized
let g:airline_detect_spell = 0 " Disable detection of spell status

map <F3> <ESC>n
imap <F3> <ESC>ni

let g:esearch = {
      \ 'adapter':    'rg',
      \ 'backend':    'vim8',
      \ 'out':        'win',
      \ 'batch_size': 1000,
      \ 'wordchars': '@,48-57,_,192-255',
      \ 'use':        ['visual', 'hlsearch', 'last'],
      \}

let g:esearch#out#win#open = 'enew'
let g:esearch#out#win#buflisted = 1
let g:esearch#util#trunc_omission = "|"

"-----------------------------------------------------------
" Navigation Commands:
" CTRL+TAB - Next File
" CTRL+SHIFT+TAB - Previous File
" CTRL+F4 - Close File
"-----------------------------------------------------------
map <C-Tab> <Esc>:bn<CR>
map <C-S-Tab> <Esc>:bp<CR>
map <C-F4> <Esc><Plug>Kwbd

if has('gui_running')
  " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
  let &guioptions = substitute(&guioptions, "t", "", "g")

  " Remove Toolbars and menubars
  " I don't ever use that and can use the extra real estate
  set guioptions-=T "remove toolbar
  set guioptions-=m "remove menu bar
endif

if executable('rg')
    let g:ackprg = 'rg --vimgrep'
endif

" <leader>a in normal mode searches for the word under the cursor
call esearch#map('<leader>a', 'esearch-word-under-cursor')

"-----------------------------------------------------------
" ALT + j/k will move lines up and down
"-----------------------------------------------------------
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL + hjkl to navigate splits
nnoremap <C-k> <C-w><Up>
nnoremap <C-j> <C-w><Down>
nnoremap <C-h> <C-w><Left>
nnoremap <C-l> <C-w><Right>

" leader q to close buffer
nnoremap <leader>q <Esc>:Kwbd<CR>
nnoremap <leader>c <Esc>:close<CR>

" leader n/p for next/previous buffer
nnoremap <leader>n <Esc>:bn<CR>
nnoremap <leader>p <Esc>:bp<CR>

" leader f to search for filename under cursor using fzf
nnoremap <leader>f <Esc>:call fzf#vim#files('', {'options':'--query='.fzf#shellescape(expand('<cfile>:t'))})<CR>

nnoremap <leader>o <Esc>:exec "e " . expand('%:p:h')<CR>

function! CodeFormat()
    if &filetype ==? "python"
        exec ":Black"
    elseif &filetype ==? "c" || &filetype ==? "cpp"
        exec ":ClangFormat"
    elseif &filetype ==? "rust"
        exec ":RustFmt"
    endif
endfunction
nnoremap <leader>I <Esc>:call CodeFormat()<CR>

" Disable arrow keys (so I learn to use hjkl)
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Useful command when debugging syntax highlighing: Shows the rules applied to
" the current cursor location
"map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

noremap <leader>l :set relativenumber!<CR>

" leader t is a shortcut for :b#
nnoremap <leader>t :b#<CR>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


augroup qf
    autocmd!
    " Don't list the quickfix or location window in the buffer list
    autocmd FileType qf set nobuflisted
augroup END

" Disable audible bell and screen flashing bell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

map <C-\> :split<CR>:exec("tag ".expand("<cword>"))<CR>
map <F12> :buffers<BAR>
           \let i = input("Buffer number: ")<BAR>
           \execute "buffer " . i<CR>

" Enable spellcheck
function! CodeSpellCheck()
    exe ":syntax spell toplevel"
    if has('win32') || has('win64')
        exe ":setlocal spellfile=" . $HOME . "/vimfiles/spell/code.latin1.add"
    else
        exe ":setlocal spellfile=" . $HOME . "/.vim/spell/code.latin1.add"
    endif
    exe ":setlocal spelllang=" . &spelllang . ",code"
endfunction

let g:code_files = [
            \ '*.bb',
            \ '*.bbappend',
            \ '*.bbclass',
            \ '*.c',
            \ '*.conf',
            \ '*.cpp',
            \ '*.fml',
            \ '*.h',
            \ '*.hpp',
            \ '*.inc',
            \ '*.ini',
            \ '*.java',
            \ '*.js',
            \ '*.json',
            \ '*.md',
            \ '*.pl',
            \ '*.pm',
            \ '*.py',
            \ '*.rules',
            \ '*.s',
            \ '*.script',
            \ '*.sh',
            \ '*.txt',
            \ '*.wks',
            \ '*.x',
            \ '*.xml',
            \ '*.yaml',
            \ '*.yml',
            \ '*gdbinit',
            \ 'meson.build',
            \ 'wscript*',
            \ ]

set spell spelllang=en_us
augroup code_files
    autocmd!
    " Treat WAF wscript as a python file
    autocmd BufNewFile,BufRead wscript* set filetype=python

    " Udev rules
    autocmd BufNewFile,BufRead *.rules set filetype=udevrules

    exe ":autocmd BufNewFile,BufRead " . join(g:code_files, ',') . " :call CodeSpellCheck()"

    " Remove trailing whitespace on various files
    exe ":autocmd BufWritePre " . join(g:code_files, ',') . " :call DelTrailSpace()"
augroup END

"-----------------------------------------------------------
" Pressing F11 will processes the make.log file and display
" the error list
" SHIFT + F11 will do the same but jump to the first error
"-----------------------------------------------------------
map <F11> :cgetfile make.log<CR>:cw<CR>
map <S-F11> :cfile make.log<CR>:cw<CR>

let g:linuxsty_patterns = [ "/linux", "/kernel" ]
let g:linuxsty_exclude_patterns = [ "/garmin/" ]

