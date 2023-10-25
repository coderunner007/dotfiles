set encoding=utf-8
scriptencoding utf-8

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" PLUGINS IMPORT{{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin()

Plug 'VundleVim/Vundle.vim'
" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" File window
Plug 'preservim/nerdtree'
" Undo tree
" Plug 'mbbill/undotree'
" Syntax checking
Plug 'sheerun/vim-polyglot'
" Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-test/vim-test'
Plug 'preservim/vimux'
" Plug 'aming/vim-mason'
" Plug 'pietalin/vim-jsx-typescript'
" TS vim plugin
" Plug 'Quramy/tsuquyomi'
" Close brackets
Plug 'jiangmiao/auto-pairs'
" Close html tags
" Plug 'alvan/vim-closetag'
" Custom motions.
Plug 'tpope/vim-surround'
" Repeat tpope commands with .
Plug 'tpope/vim-repeat'
" Comments autocompletion
Plug 'tpope/vim-commentary'
" Git helpers
Plug 'tpope/vim-fugitive'
" Handy actions
Plug 'tpope/vim-unimpaired'
" Colored color codes
Plug 'chrisbra/Colorizer'
" Show space with |
" Plug 'Yggdroot/indentLine'
" show git-diff in gutter
Plug 'airblade/vim-gitgutter'
" statusline: airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'altercation/vim-colors-solarized'
" Plug 'altercation/solarized'
Plug 'joshdick/onedark.vim'
call plug#end()
" }}}

" COLORSCHEME {{{
filetype plugin indent on
syntax on
if exists('+termguicolors')
        set termguicolors
endif
" set background=dark
" https://stackoverflow.com/a/7278548
" let g:solarized_termcolors=256
" colorscheme solarized
colorscheme onedark
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

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0) " fzf.vim Ag do not match filenames.
" SEARCH {{{
set incsearch                                                                 " search characters when entered
set hlsearch                                                                  " highlight matches
set ignorecase                                                                " case insensitive
set smartcase                                                                 " case sensitive if has capital letters
" }}}
" }}}

" EXPERMIMENTAL {{{
" set tags=tags                                                                 " look for ctags file
" Change cursor in VIM https://stackoverflow.com/a/42118416
" let &t_SI = "\e[6 q"
" let &t_EI = "\e[2 q"

" autocmd! BufRead,BufNewFile *.m setfiletype mason
" autocmd! BufRead,BufNewFile *.mi setfiletype mason
" au BufRead *.m :set filetype=mason
" au BufRead *.mi :set filetype=mason
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
nnoremap <leader>g :Files<CR>
nnoremap <leader>G :GFiles<CR>
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

" GUI SETTINGS {{{
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove scrollbar-right
set guioptions-=L  "remove scrollbar-left
" }}}

" PLUGIN SETTINGS {{{
" " indentLine {{{
" let g:indentLine_char = '|'
" " }}}

" vim-test {{{
let test#strategy = "vimux"
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
" nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>
" }}}

" NERDTree {{{
let NERDTreeHijackNetrw=1
" }}}

" COC {{{
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
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
let g:airline_theme='onedark'
" }}}

" }}}

