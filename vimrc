runtime bundle/vim-pathogen/autoload/pathogen.vim

let g:pathogen_disabled = ["vim-gitgutter"]
execute pathogen#infect()

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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
colorscheme NeoSolarized

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
let g:gitgutter_sign_column_always = 1 " Always show sign column

set laststatus=2    "Always show status line
let g:airline#extensions#tabline#enabled = 1 " Show buffer list in airline
let g:airline_powerline_fonts = 1 " Use Powerline fonts
let g:airline_theme = 'dark' " Use the default airline theme. I like it better than solarized
let g:airline_detect_spell = 0 " Disable detection of spell status

map <F3> <ESC>n
imap <F3> <ESC>ni

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
  if has('win32') || has('win64')
    set guifont=Hack:h9
  else
    set guifont=Hack\ 9
  endif

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
nmap <expr> <leader>a GetFindAck('FindAck!', expand("<cword>"))

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

" leader n/p for next/previous buffer
nnoremap <leader>n <Esc>:bn<CR>
nnoremap <leader>p <Esc>:bp<CR>

" Disable arrow keys (so I learn to use hjkl)
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

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



" Remove trailing whitespace on various files
autocmd BufWritePre *.java,*.pl,*.pm,*.c,*.h,*.cpp,*.hpp,*.xml,*.fml,*.py,*.x,*.s,*.inc,*.sh,*.ini,*gdbinit,*.bb,*.bbappend,*.bbclass,*.conf,wscript,*.txt,*.js :call DelTrailSpace()

" Treat WAF wscript as a python file
au BufNewFile,BufRead wscript* set filetype=python

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

set spell spelllang=en_us
autocmd BufNewFile,BufRead *.java,*.pl,*.pm,*.c,*.h,*.cpp,*.hpp,*.xml,*.fml,*.py,*.x,*.s,*.inc,*.sh,*.ini,*gdbinit,*.bb,*.bbappend,*.bbclass,*.conf,wscript,*.js :call CodeSpellCheck()

"-----------------------------------------------------------
" Pressing F11 will processes the make.log file and display
" the error list
" SHIFT + F11 will do the same but jump to the first error
"-----------------------------------------------------------
map <F11> :cgetfile make.log<CR>:cw<CR>
map <S-F11> :cfile make.log<CR>:cw<CR>

let g:linuxsty_patterns = [ "/linux", "/kernel" ]

