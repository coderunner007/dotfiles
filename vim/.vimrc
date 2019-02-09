set encoding=utf-8
scriptencoding utf-8

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
" Undo tree
" Plugin 'mbbill/undotree'
" Syntax checking
Plugin 'w0rp/ale'
Plugin 'sheerun/vim-polyglot'
Plugin 'pietalin/vim-jsx-typescript'
" TS vim plugin
Plugin 'Quramy/tsuquyomi'
" Close brackets
Plugin 'jiangmiao/auto-pairs'
" Close html tags
Plugin 'alvan/vim-closetag'
" Custom motions.
Plugin 'tpope/vim-surround'
" Repeat tpope commands with .
Plugin 'tpope/vim-repeat'
" Comments autocompletion
Plugin 'tpope/vim-commentary'
" Git helpers
Plugin 'tpope/vim-fugitive'
" Handy actions
Plugin 'tpope/vim-unimpaired'
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
" Plugin 'rafi/awesome-vim-colorschemes'
" Plugin 'altercation/vim-colors-solarized'
call vundle#end()
" }}}

" COLORSCHEME {{{
filetype plugin indent on
syntax on
if (has("termguicolors"))
 set termguicolors
endif
colorscheme al-custom
set background=dark
" }}}

" BASIC CONFIG {{{
set splitbelow                                                                " set default horizontal split below
set splitright                                                                " set default vertical split right
set noswapfile                                                                " no .swp created
set encoding=utf-8                                                            " Default encoding linux
set nu                                                                        " set line numbers
set foldmethod=syntax                                                         " folding
" set foldlevelstart=10                                                         " open most folds by default
" set foldnestmax=10                                                            " 10 nested fold max
set history=200
set foldlevel=0
set cursorline                                                                " highlight current line
set wildmenu                                                                  " show menu on statusline when command completing
runtime macros/matchit.vim                                                    " match closing tags

" SEARCH {{{
set incsearch                                                                 " search characters when entered
set hlsearch                                                                  " highlight matches
set ignorecase                                                                " case insensitive
set smartcase                                                                 " case sensitive if has capital letters
" }}}
" }}}

" WHITESPACE {{{
" PER FILE WHITESPACE DEFINITIONS {{{
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

" SHOW BAD WHITESPACE {{{
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw,*.js,*.html,*.jsx,*.ts,*.tsx match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.jsx,*.html,*.ts,*.tsx match BadWhitespace /\s\+$/
" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h,*.js,*.jsx,*.html,*.ts,*.tsx set fileformat=unix
" 80-line highlight
highlight OverLength ctermbg=darkgrey guibg=#592929
2match OverLength /\%81v.\+/
" set background color
highlight Normal ctermfg=white ctermbg=235
" }}}
" }}}

" CUSTOM KEY MAPPINGS {{{
" TOGGLES {{{
set pastetoggle=<F2>
nnoremap <silent> <F3> :GFiles<CR>
nnoremap <silent> <C-F3> :Files<CR>
nnoremap <silent> <F4> :ColorToggle<CR>
nnoremap <silent> <F5> :Ag<CR>
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:noh<CR>
" }}}

" VIM TABS {{{
nnoremap th :tabprevious<CR>
nnoremap tl :tabnext<CR>
nnoremap tq :tabclose<CR>
nnoremap to :tabe<CR>
nnoremap tH :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap tL :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
" }}}

" LEADER MAPPINGS {{{
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>x :bufdo bw<CR>
" Turn off search highlight
nnoremap <leader>; :noh<CR>
nnoremap <leader>r :TsuRenameSymbol<CR>
nnoremap <leader>u :UndotreeToggle<CR>
" toggle mappings
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>b :Buffers<CR>
" }}}

" SNIPPET MAPPINGS {{{
" React Snippets.
nnoremap ,modal :-1read $HOME/.vim/snippets/modal.tsx<CR>
nnoremap ,tabs :-1read $HOME/.vim/snippets/tabs.tsx<CR>
" }}}

" EX-MODE REMAPPINGS {{{
" Map to Up, Down keys for filter functionality
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" }}}

" }}}

" SAVED MACROS {{{
let @q = 'cs"'lva'S)lva)S}liclassnames'
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
let g:ale_fixers = {
\   'typescript': [
\       'tslint',
\   ],
\   'typescript.jsx': [
\       'tslint',
\   ],
\}
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

" Airline {{{
let g:airline#extensions#ale#enabled = 1
let g:airline_section_z = '%3l/%L:%3v'
let g:airline_theme='solarized'
" }}}

" vim-jsx-typescript {{{
" set filetypes as typescript.jsx also set colorscheme here,
" since vim-jsx-typescript tags will only be available when
" it is enabled.
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.jsx | colorscheme al-custom
" }}}
" }}}

set modelines=1
" vim:foldmethod=marker:foldlevel=0
