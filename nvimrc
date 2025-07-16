let mapleader=" "
syntax on
set number
set relativenumber
set cursorline
set wrap
set showcmd
set wildmenu
"set nosmartindent
"set nocindent
"set autoindent  " 可选：保留基本自动缩进

set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set mouse=a
set encoding=utf-8
let &t_ut=''
" set list
" 缩进配置
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set scrolloff=5
set tw=0
set indentexpr= 
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
set laststatus=2
set autochdir
au BufReadPost * if line("'\'") > 1 && line("'\'") <= line("$") | exe "normal! g'\"" | endif

noremap <LEADER><CR> :nohlsearch<CR>
" 方向映射
noremap j h
noremap k j
noremap i k
noremap I 5k
noremap K 5j
noremap L 5l
noremap J 5h

noremap h i
noremap H I

" 剪切板适配
vnoremap <C-c> :w !wl-copy<CR><CR>

" 保存/退出 
map s :<nop> 
map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>

" 窗口分块
noremap sl :set splitright<CR>:vsplit<CR>
noremap sj :set nosplitright<CR>:vsplit<CR>
noremap si :set nosplitbelow<CR>:split<CR>
noremap sk :set splitbelow<CR>:split<CR>
noremap ss :NERDTree<CR>
" 窗口光标移动
noremap <LEADER>i <C-w>k
noremap <LEADER>j <C-w>h
noremap <LEADER>k <C-w>j
noremap <LEADER>l <C-w>l
" 窗口位置
noremap sv <C-w>t<C-w>H
noremap sh <C-w>t<C-w>K
" 更改分屏大小
noremap <C-Up> :res +5<CR>
noremap <C-Down> :res -5<CR>
noremap <C-Left> :vertical resize-5<CR>
noremap <C-Right> :vertical resize+5<CR>
" 标签页
noremap tk :tabe<CR>
noremap tj :-tabnext<CR>
noremap tl :+tabnext<CR>

" 插件安装
let s:vimrc_dir = fnamemodify(resolve($MYVIMRC), ':p:h')
let s:plug_dir = s:vimrc_dir . '/../nvim/plugged'
call plug#begin(s:plug_dir)

Plug 'vim-airline/vim-airline'
Plug 'connorholyday/vim-snazzy'
Plug 'scrooloose/nerdtree'
Plug 'iamcco/markdown-preview.nvim'

call plug#end()

let g:SnazzyTransparent = 1
color snazzy


noremap <F8> :MarkdownPreview<CR>
