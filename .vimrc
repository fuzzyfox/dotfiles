set autoindent
set backspace=2     " backspace over indents, newlines, and insert origin
set nocompatible
set encoding=utf-8
set esckeys         " use cursor keys in insert mode
set noexpandtab
set nohlsearch      " do not highlight matched search terms
set incsearch       " incremental search
set linebreak       " do not break words when wrapping line
set modeline        " honour vim modelines
set mouse=vic       " use mouse in visual, insert, and ex modes
set ruler           " show line and column in bottom right
set scrolloff=20    " minimum lines of context above & below cursor
set showbreak=…     " prefix wrapped lines with ellipsis
set showcmd         " show partial commands
set noshowmatch     " matchparen plugin will take care of this
set showmode
set tabstop=4
set visualbell
set number

"set undofile        " persistent undo (since 7.3 only)
"set undodir=~/.vim/undo
set autowrite       " automatically save before :next, :make, etc

syntax on

nmap Y y$

nmap <silent> Zz :w<CR>
nmap <silent> `  :bn<CR>
nmap <silent> ~  :bp<CR>

" vim: et ts=2
