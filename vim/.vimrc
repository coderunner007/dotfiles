set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" vundle plugin manager
Plugin 'VundleVim/Vundle.vim'

" Fuzzy finder
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" File window
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Syntax checking
" Plugin 'scrooloose/syntastic'
" Plugin 'nvie/vim-flake8'
" Plugin 'vim-scripts/indentpython.vim'
Plugin 'w0rp/ale'
" Plugin 'leafgarland/typescript-vim'
" Plugin 'mxw/vim-jsx'
" Plugin 'pangloss/vim-javascript'
Plugin 'sheerun/vim-polyglot'
Plugin 'pietalin/vim-jsx-typescript'

" TS vim plugin
Plugin 'Quramy/tsuquyomi'

" Python Code Folding
" Plugin 'tmhedberg/SimpylFold'

" Autocomplete
Plugin 'Valloric/YouCompleteMe'
" Close brackets
Plugin 'Raimondi/delimitMate'
" Close html tags
Plugin 'alvan/vim-closetag'
" Tag editing
Plugin 'tpope/vim-surround'

" Colored color codes
Plugin 'chrisbra/Colorizer'

" Git
Plugin 'tpope/vim-fugitive'

" Show space with |
Plugin 'Yggdroot/indentLine'

" show git-diff in gutter
Plugin 'airblade/vim-gitgutter'

" Color scheme
" Plugin 'rafi/awesome-vim-colorschemes'
" Plugin 'altercation/vim-colors-solarized'
Plugin 'joshdick/onedark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()
filetype plugin indent on

" PERSONAL
let python_highlight_all=1
syntax on
colorscheme onedark
" set vertical and horizontal split locations.
set splitbelow
set splitright

" no .swp created
set noswapfile

" encoding and line numbers
set encoding=utf-8
set nu

" Search Tags file from current directory till home
set tags=./tags,tags;$HOME

" indentLine settings
let g:indentLine_char = '|'

nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" ALE settings
" let g:ale_linters = {
" \   'javascript': ['eslint'],
" \   'python': ['flake8'],
" \}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'

" typescript-vim settings
" let g:typescript_indent_disable = 1

" fzf.vim settings
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

" Allow JSX in normal JS files
let g:jsx_ext_required = 0

" vim-closetag settings
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_emptyTags_caseSensitive = 1

" you-complete-me preview close
set completeopt-=preview
let g:ycm_python_binary_path = '/usr/bin/python3'

" delimitMate enable
let delimitMate_expand_cr = 1

" let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" split window navigation
nnoremap sj <C-W><C-J>
nnoremap sk <C-W><C-K>
nnoremap sl <C-W><C-L>
nnoremap sh <C-W><C-H>
" tab navigation
nnoremap th :tabprevious<CR>
nnoremap tl :tabnext<CR>
nnoremap <silent> <S-h> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <S-l> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" file manager toggle
" nnoremap <silent> <C-N> :NERDTreeToggle<CR>

" toggle paste-nopaste
set pastetoggle=<F2>

" open FZF
nnoremap <silent> <F3> :Files<CR>

" Colorizer toggle
nnoremap <silent> <F4> :ColorToggle<CR>

" open Ag
nnoremap <silent> <F5> :Ag<CR>

" whitespace removal
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" match closing html tags
runtime macros/matchit.vim

" whitespace formatting for different file types
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
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw,*.js,*.html,*.jsx,*.ts,*.tsx match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.jsx,*.html,*.ts,*.tsx match BadWhitespace /\s\+$/
" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.jsx,*.html,*.ts,*.tsx set fileformat=unix
" typescript syntax highlighting
autocmd BufRead,BufNewFile *.ts,*.tsx set filetype=typescript.jsx
" 80-line highlight
highlight OverLength ctermbg=darkgrey guibg=#592929
2match OverLength /\%81v.\+/
" set background color
highlight Normal ctermfg=white ctermbg=235
" /PERSONAL
