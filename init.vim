if &compatible
  set nocompatible
endif

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

if has('nvim') && executable('pyenv')
  if executable($HOME . '/.pyenv/versions/neovim2/bin/python')
    let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
  endif
  if executable($HOME . '/.pyenv/versions/neovim3/bin/python')
    let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
  endif
endif

if has('python3') && !has('patch-8.1.201')
  silent! python3 1
endif

if !empty(&runtimepath)
  let s:vimfiles = split(&runtimepath, ',')[0]
else
  echohl ErrorMsg
  echomsg 'Unable to determine runtime path for Vim.'
  echohl NONE
endif

filetype off

" Install vim-plug if it isn't installed
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
    finally
      if isdirectory(tmp)
        let dir = '"' . escape(tmp, '"') . '"'
        silent call system((has('win32') ? 'rmdir /S /Q ' : 'rm -rf ') . dir)
      endif
    endtry
  endif
endfunction

" Install missing plugins
function! s:InstallMissingPlugins()
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
    PlugInstall --sync
  endif
endfunction

call s:DownloadVimPlug()
call plug#begin(s:vimfiles . '/plugged')

" Vim default"
Plug 'tpope/vim-sensible'

" Cosmetics"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jpo/vim-railscasts-theme'
Plug 'luochen1990/rainbow'
Plug 'hashivim/vim-terraform'

" Git"
Plug 'airblade/vim-gitgutter'

" Misc"
Plug 'tpope/vim-surround'

" Language Server Manager"
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Autocompletion"
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'p00f/clangd_extensions.nvim'

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

" Settings for GitGutter"
set updatetime=100

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

" Settings for CoQ.nvim"
let g:coq_settings = { 'auto_start': 'shut-up' }

lua << EOF

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "pyright",
        "sumneko_lua",
        "vimls",
        "yamlls",
        "terraformls",
        "jdtls",
        "bashls",
        "dockerls"
    }
})

local lsp = require "lspconfig"
local coq = require "coq"

require("clangd_extensions").setup {
    server = {
        coq.lsp_ensure_capabilities()
    },
}
lsp.pyright.setup(coq.lsp_ensure_capabilities())
lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities())
lsp.vimls.setup(coq.lsp_ensure_capabilities())
lsp.yamlls.setup(coq.lsp_ensure_capabilities())
lsp.terraformls.setup(coq.lsp_ensure_capabilities())
lsp.jdtls.setup(coq.lsp_ensure_capabilities())
lsp.bashls.setup(coq.lsp_ensure_capabilities())
lsp.dockerls.setup(coq.lsp_ensure_capabilities())

require("coq_3p"){
    { src = "nvimlua", short_name = "nLUA" , conf_only = true},
    { src = "bc", short_name = "MATH", precision = 6 },
}

EOF