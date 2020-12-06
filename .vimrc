set encoding=utf-8
scriptencoding utf-8
let mapleader = ','
let maplocalleader = '\\'
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" changed vim window mapping from having to use pinky on left hand :)
nnoremap <leader>w <C-w>

" mappings to go to first,last,prev and next errors in locatio list
nnoremap <leader>fe :lfir <cr>
nnoremap <leader>le :lla <cr>
nnoremap <leader>ne :lnext <cr>
nnoremap <leader>pe :lprev <cr>

" diable <esc> key and remap to 'kj'
inoremap <esc> <nop>
inoremap kj <esc>

"disable arrow keys - force learn hjkl"
if v:version >= 703
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
    "Function to toggle from number to relative number"
    "set Hybrid mode as default
    set number relativenumber

    function! NumberToggle()
        if(&relativenumber == 1)
            set norelativenumber | set number
        else
            set number relativenumber
        endif
    endfunc

    nnoremap <F3> :call NumberToggle()<cr>

    "Auto change from hybrid mode to number while turning on cursor and
    "setting color to lightblue
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,Insertleave,WinEnter * hi CursorLineNr cterm=None ctermfg=lightblue gui=None guifg=lightblue
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu cursorline | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu nocursorline | endif
    augroup END

else
    "if version isnt >= 703 set to just number
    set number
endif

" Read-only odt/odp through odt2txt
augroup odt2txt
    autocmd!
    autocmd BufReadPre *.odt,*.odp silent set ro
    autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"
augroup END

" allow colors to work for powerline"
set t_Co=256
"allow backspace to remove all spaces of 'tab'"
set softtabstop=4

" Remapped highlight search. <F4> is used in vimspector by default
:noremap <leader>hl :set hlsearch! hlsearch?<CR>

"-----------------------------------------------------------
" vim as python ide below
"-----------------------------------------------------------
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#rc()

" let Vundle manage Vundle
" required!
Plugin 'VundleVim/Vundle.vim'
" The bundles you install will be listed here
Plugin 'klen/python-mode'
Plugin 'davidhalter/jedi-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tcomment'
Plugin 'Solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'SirVer/ultisnips'
Plugin 'Raimondi/delimitMate'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'pearofducks/ansible-vim'
Plugin 'junegunn/vader.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'puremourning/vimspector'

let g:vimspector_enable_mappings = 'HUMAN'
augroup vimspector
    nmap <F7> <Plug>VimspectorStepInto
    nnoremap <leader>dx :VimspectorReset<CR>
    nnoremap <leader>dc :VimspectorShowOutput Console<CR>
    nnoremap <leader>de :VimspectorShowOutput stderr<CR>
    nnoremap <leader>dt :VimspectorShowOutput Telemetry<CR>
    nnoremap <leader>ds :VimspectorShowOutput server<CR>
    nnoremap <leader>V :call win_gotoid( g:vimspector_session_windows.variables )<CR>
    nnoremap <leader>W :call win_gotoid( g:vimspector_session_windows.watches )<CR>
    nnoremap <leader>S :call win_gotoid( g:vimspector_session_windows.stack_trace )<CR>
    nnoremap <leader>C :call win_gotoid( g:vimspector_session_windows.code )<CR>
augroup END

filetype plugin indent on

let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

" Needed for javacomplete2
augroup javacomplete2
    autocmd!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup END

" change theme to easier reading "
set background=dark
colorscheme solarized

"set the Background color for highlighted searches"
:hi Search cterm=bold ctermfg=grey ctermbg=darkblue

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
nnoremap  <F2> :NERDTreeToggle<cr>
"End NerdTREE

"Syntastic Settings
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }
let g:syntastic_enable_signs=1
let g:syntastic_java_checkers=['javac']
let g:syntastic_javac_config_file_enabled = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=0
let g:syntastic_yaml_checkers=['yamllint']
let g:syntastic_vim_checkers=['vint']


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
let g:pymode_lint_checker = 'pyflakes,pep8'
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
" let g:pymode_folding = 0

" End Python-mode----------------------------------------------------

" hi EOLWhitespace ctermbg=red
" match EOLWhitespace /\s\+$/

" Use ,l to toggle display of whitespace
" Don't map L as it is a standard motion key (LOW)
set list!
nnoremap <leader>l :set list!<CR>
" And set some nice chars to do it with
" set listchars=tab:»\ ,eol:¬,trail:-
set listchars=tab:»-,trail:\ ,eol:¬
" Specialkey is used for highlighing 'trail' above
" see :help listchars
hi Specialkey ctermbg=red
hi NonText ctermfg=blue
" automatically change window's cwd to file's dir
set autochdir
" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab
" Settings for yaml files .ansible is added for ansible-lint
augroup ansible-lint
    autocmd!
    autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml.ansible foldmethod=manual
    autocmd FileType yaml.ansible setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
    endif

" Change default behavior of 'gf' Goto File to split mode instead of current
" window
 nnoremap gf <C-W>f
 vnoremap gf <C-W>f
