function! s:VersionRequirement(val, min)
    for idx in range(0, len(a:min) - 1)
        let v = get(a:val, idx, 0)
        if v < a:min[idx]
            return 0
        elseif v > a:min[idx]
            return 1
        endif
    endfor
    return 1
endfunction

if has('python')
    redir => s:pyv
    silent python import platform; print(platform.python_version())
    redir END

    let s:python26 = s:VersionRequirement(
            \ map(split(split(s:pyv)[0], '\.'), 'str2nr(v:val)'), [2, 6])
else
    let s:python26 = 0
endif

if !empty(&rtp)
    let s:vimfiles = split(&rtp, ',')[0]
else
    echohl ErrorMsg
    echomsg 'Unable to determine runtime path for Vim.'
    echohl NONE
endif

" Vim settings "
set nocompatible              " be iMproved, required
filetype off                  " required

" Install vim-plug if it isn't installed and call plug#begin() out of box
function! s:DownloadVimPlug()
    if !exists('s:vimfiles')
        return
    endif
    if empty(glob(s:vimfiles . '/autoload/plug.vim'))
        let plug_url = 'https://github.com/junegunn/vim-plug.git'
        let tmp = tempname()
        let new = tmp . '/plug.vim'

        try
            let out = system(printf('git clone --depth 1 %s %s', plug_url, tmp))
            if v:shell_error
                echohl ErrorMsg
                echomsg 'Error downloading vim-plug: ' . out
                echohl NONE
                return
            endif

            if !isdirectory(s:vimfiles . '/autoload')
                call mkdir(s:vimfiles . '/autoload', 'p')
            endif
            call rename(new, s:vimfiles . '/autoload/plug.vim')

        " Install plugins at first
        autocmd VimEnter * PlugInstall | quit
        finally
            if isdirectory(tmp)
                let dir = '"' . escape(tmp, '"') . '"'
                silent call system((has('win32') ? 'rmdir /S /Q ' : 'rm -rf ') . dir)
            endif
        endtry
    endif
    call plug#begin(s:vimfiles . '/plugged')
endfunction

call s:DownloadVimPlug()

Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jpo/vim-railscasts-theme'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'luochen1990/rainbow'

" All of your Plugins must be added before the following line
call plug#end()            " required

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
set cursorline
autocmd vimrc FileType html,php,js,css setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Set vim colorscheme to railscasts "
try
  colorscheme railscasts
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry

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

" Settings for vim-airline"
let g:airline_powerline_fonts = 1
let g:airline_theme = 'murmur'

" Settings for RainbowParenthesis"
let g:rainbow_active = 1
