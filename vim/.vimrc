" PLUGINS IMPORT{{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" Fuzzy finder
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" File window
Plugin 'scrooloose/nerdtree'
" Undotree visualize
Plugin 'mbbill/undotree'
" Syntax checking
Plugin 'w0rp/ale'
Plugin 'sheerun/vim-polyglot'
Plugin 'pietalin/vim-jsx-typescript'
" TS vim plugin
Plugin 'Quramy/tsuquyomi'
" Autocomplete
Plugin 'Valloric/YouCompleteMe'
" Close brackets
Plugin 'jiangmiao/auto-pairs'
" Close html tags
Plugin 'alvan/vim-closetag'
" Tag editing
Plugin 'tpope/vim-surround'
" Repeat tpope commands with .
Plugin 'tpope/vim-repeat'
" Comments autocompletion
Plugin 'tpope/vim-commentary'
" Git helpers
Plugin 'tpope/vim-fugitive'
" Colored color codes
Plugin 'chrisbra/Colorizer'
" Show space with |
Plugin 'Yggdroot/indentLine'
" show git-diff in gutter
Plugin 'airblade/vim-gitgutter'
" statusline: airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Color scheme
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'altercation/vim-colors-solarized'
call vundle#end()
" }}}

" COLORS SCHEME {{{
filetype plugin indent on
syntax on
if (has("termguicolors"))
 set termguicolors
endif
colorscheme solarized8
" }}}

" BASIC CONFIG {{{
set splitbelow                                                                " set default horizontal split below
set splitright                                                                " set default vertical split right
set noswapfile                                                                " no .swp created
set encoding=utf-8                                                            " Default encoding linux
set nu                                                                        " set line numbers
set foldmethod=syntax                                                         " folding
set foldlevelstart=10                                                         " open most folds by default
set foldnestmax=10                                                            " 10 nested fold max
set cursorline                                                                " highlight current line
runtime macros/matchit.vim                                                    " match closing tags
" }}}

" WHITESPACE FORMATTING {{{ 
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

au BufNewFile,BufRead *.js,*.html,*.css,*.jsx,*.ts,*.tsx,*.scss,*.json
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
set expandtab
" }}}

" KEY REMAPPINGS {{{
set pastetoggle=<F2>
nnoremap <silent> <F3> :GFiles<CR>
nnoremap <silent> <C-F3> :Files<CR>
nnoremap <silent> <F4> :ColorToggle<CR>
nnoremap <silent> <F5> :Ag<CR>
nnoremap <silent> <F9> :UndotreeToggle<CR>
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" TABS {{{
nnoremap th :tabprevious<CR>
nnoremap tl :tabnext<CR>
nnoremap <silent> <S-h> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <S-l> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
" }}}

" }}}

" SEARCH {{{
set incsearch                                                                 " search characters when entered
set hlsearch                                                                  " highlight matches
" Turn of search highlight on enter press
nnoremap <CR> :noh<CR><CR>
" }}}

" PLUGIN SETTINGS {{{
" indentLine {{{
let g:indentLine_char = '|'
" }}}

" NERDTree {{{
let NERDTreeHijackNetrw=1
" }}}

" ALE {{{
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
" }}}

" FZF {{{
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" }}}

" vim-jsx {{{
let g:jsx_ext_required = 0                                                    " Allow jsx highlighting in js files
" }}}

" vim-closetag {{{
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_emptyTags_caseSensitive = 1
" }}}

" YouCompleteMe {{{
set completeopt-=preview
let g:ycm_python_binary_path = '/usr/bin/python3'
" }}}

" delimitMate {{{
" let delimitMate_expand_cr = 1
" }}}

" Airline {{{
let g:airline#extensions#ale#enabled = 1
" let g:airline_powerline_fonts = 1
let g:airline_section_z = '%3l/%L:%3v'
" }}}
" }}}

set modelines=1
" vim:foldmethod=marker:foldlevel=0
