"disable arrow keys - force learn hjkl"
map <Left> <nop>
map <Right> <nop>
map <Up> <nop>
map <Down> <nop>
if version >= 703
    "Function to toggle from number to relative number"
    function! NumberToggle()
        if(&relativenumber == 1)
            set number
        else
            set relativenumber
        endif
    endfunc

    nnoremap <F3> :call NumberToggle()<cr>
    :au FocusLost * :set number
    :au FocusGained * :set relativenumber
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
    "set default numbering"
    set relativenumber
else
    set number
endif

" allow colors to work for powerline"
set t_Co=256
"allow backspace to remove all spaces of 'tab'"
set softtabstop=4
" Press Space to turn off highlighting and clear any message already
" displayed.
:noremap <F4> :set hlsearch! hlsearch?<CR>
"set the Background color for highlighted searches"
:hi Search ctermbg=23



"-----------------------------------------------------------
" vim as python ide below 
"-----------------------------------------------------------
set nocompatible
filetype off

set rtp+=$HOME/.vim/bundle/powerline/powerline/bindings/vim/
set rtp+=~/.vim/bundle/vundle/

call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
" The bundles you install will be listed here
" Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'Lokaltog/powerline'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tcomment'
Bundle 'Solarized'

" change theme to easier reading "
set background=dark
colorscheme solarized

filetype plugin indent on

" The rest of your config follows here
augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

"NeardTREE
map  <F2> :NERDTreeToggle
"End NerdTREE


" Python-mode
" Activate rope
" Keys:
" K             Show python docs
"   Rope autocomplete
" g     Rope goto definition
" d     Rope show documentation
" f     Rope find occurrences
" b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator
" modes)
" ]]            Jump on next class or function (normal, visual, operator
" modes)
" [M            Jump on previous class or method (normal, visual, operator
" modes)
" ]M            Jump on next class or method (normal, visual, operator
" modes)
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
""let g:pymode_lint_write = 1
let g:pymode_lint_on_fly = 1
" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = 'b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" End Python-mode----------------------------------------------------

" Use L to toggle display of whitespace
nmap L :set list!
" And set some nice chars to do it with
set listchars=tab:»\ ,eol:¬
" automatically change window's cwd to file's dir
set autochdir
" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab
" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
    endif
