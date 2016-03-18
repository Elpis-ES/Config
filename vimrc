" Vim settings "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-surround'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Define vimrc autogroup "
augroup vimrc
    autocmd!
augroup END

" General settings for vim "
syntax enable
set number
set autoread
set backspace=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=4
set expandtab
set smartindent
set nowrap
autocmd vimrc FileType html,php,js,css setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Set vim colorscheme to railscasts "
colorscheme railscasts


" Enable list mode "
set list

" Strings to use in 'list' mode and for the :list command "
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+


" Aliases for common mistakes "
command! WQ wq
command! Wq wq
command! W w
command! Q q

" Highlight trailing spaces "
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd vimrc BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd vimrc InsertEnter * match ExtraWhitespace //
autocmd vimrc InsertLeave * match ExtraWhitespace /\s\+$/
if version >= 702
    autocmd vimrc BufWinLeave * call clearmatches()
endif

autocmd vimrc FileType *
    \ setlocal formatoptions-=c |
    \ setlocal formatoptions-=o |
    \ if (v:version >= 704 || v:version == 703 && has('patch541')) |
    \ setlocal formatoptions+=j |
    \ endif

" Settings for Tagbar"
let g:tagbar_left = 1
autocmd vimenter * nested :TagbarOpen

" Settings for NerdTree "
autocmd vimenter * NERDTree | wincmd l |
            \ wincmd J | wincmd W |
            \ wincmd L | NERDTreeFocus |
            \ execute "normal AA" | wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let g:NERDTreeShowHidden = 1
