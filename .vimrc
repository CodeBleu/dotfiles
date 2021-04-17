set encoding=utf-8
scriptencoding utf-8
let mapleader = ' '
let maplocalleader = ','
nnoremap <localleader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>sv :source $MYVIMRC<cr>
" changed vim window mapping from having to use pinky on left hand :)
nnoremap <localleader>w <C-w>
" mappings to go to first,last,prev and next errors in locatio list
nnoremap <localleader>fe :lfir <cr>
nnoremap <localleader>le :lla <cr>
nnoremap <localleader>ne :lnext <cr>
nnoremap <localleader>pe :lprev <cr>
" open new horizontal/vertical windows
nnoremap <localleader>w- :split new<cr>
nnoremap <localleader>w\ :vsplit new<cr>
" Needed for autoload of CtrlP Plugin
nnoremap <C-p> :CtrlP<cr>

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
:noremap <localleader>hl :set hlsearch! hlsearch?<cr>

set nocompatible

" The ':syntax enable' command will keep your current color settings.  This
" allows using ':highlight' commands to set your preferred colors before or
" after using this command.  If you want Vim to overrule your settings with the
" defaults, use: >
"     :syntax on

" Install vim-plug if not found
if !exists('g:syntax_on')
    syntax enable
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
augroup vimplug
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
    \| endif
augroup END

call plug#begin('~/.vim/plugged')
" The plugins you install will be listed here
Plug 'junegunn/vim-plug'
Plug 'klen/python-mode'
Plug 'davidhalter/jedi-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/tComment'
Plug 'vim-scripts/Solarized'
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP'}
Plug 'vimwiki/vimwiki'
if v:version >= 800
    Plug 'dense-analysis/ale'
    Plug 'puremourning/vimspector', { 'for': 'python,sh'}
else
    Plug 'scrooloose/syntastic'
endif
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java'}
if has('python3') && v:version >= 740
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'pearofducks/ansible-vim'
Plug 'junegunn/vader.vim', { 'for': 'vim' }
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Our personal snippets go into ~/dotfiles/vim_user_snippets.
" By defining the below, it opens new file at this location.
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit='~/dotfiles/vim_user_snippets'

" Open UltiSnipEdit in split window
let g:UltiSnipsEditSplit='vertical'

" Add your private snippet path to runtimepath
set runtimepath^=~/dotfiles

" When vim starts, Ultisnips tries to find snippet directories defined below, under the paths in runtimepath.
let g:UltiSnipsSnippetDirectories=[ 'UltiSnips', 'vim_user_snippets']

nnoremap <localleader>es :UltiSnipsEdit<cr>

if v:version >= 800
    let g:vimspector_enable_mappings = 'HUMAN'
    augroup vimspector
        nmap <F7> <Plug>VimspectorStepInto
        nnoremap <localleader>dx :VimspectorReset<cr>
        nnoremap <localleader>dc :VimspectorShowOutput Console<cr>
        nnoremap <localleader>de :VimspectorShowOutput stderr<cr>
        nnoremap <localleader>dt :VimspectorShowOutput Telemetry<cr>
        nnoremap <localleader>ds :VimspectorShowOutput server<cr>
        nnoremap <localleader>V :call win_gotoid( g:vimspector_session_windows.variables )<cr>
        nnoremap <localleader>W :call win_gotoid( g:vimspector_session_windows.watches )<cr>
        nnoremap <localleader>S :call win_gotoid( g:vimspector_session_windows.stack_trace )<cr>
        nnoremap <localleader>C :call win_gotoid( g:vimspector_session_windows.code )<cr>
    augroup END
endif


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
augroup nerdtree
    nnoremap  <F2> :NERDTreeToggle<cr>
    autocmd FileType nerdtree setlocal relativenumber
    let NERDTreeShowLineNumbers=1
augroup END
"End NerdTREE

"vimwiki
augroup vimwiki
    map  <localleader><space> <Plug>VimwikiToggleListItem
    let g:vimwiki_listsyms = ' ○◐●✓'
augroup END
"End vimwiki

if v:version >= 800
    augroup ale
        let g:ale_fixers = {
          \ '*': ['remove_trailing_lines', 'trim_whitespace']
          \ }
        let g:ale_fix_on_save = 1
    augroup END
else
    " Syntastic Settings
    let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }
    let g:syntastic_enable_signs=1
    let g:syntastic_java_checkers=['javac']
    let g:syntastic_javac_config_file_enabled = 1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_auto_jump=0
    let g:syntastic_yaml_checkers=['yamllint']
    let g:syntastic_vim_checkers=['vint']
endif

"-----------------------------------------------------------
" vim as python ide below
"-----------------------------------------------------------

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
" If vim version is > 8 we are using ALE linting above
if v:version <= 800
    "Linting
    let g:pymode_lint = 1
    let g:pymode_lint_checker = 'pylint,pyflakes,pep8'
    " Auto check on save
    ""let g:pymode_lint_write = 1
    let g:pymode_lint_on_fly = 1
    " syntax highlighting
    let g:pymode_syntax = 1
    let g:pymode_syntax_all = 1
    let g:pymode_syntax_indent_errors = g:pymode_syntax_all
    let g:pymode_syntax_space_errors = g:pymode_syntax_all
    let g:pymode_virtualenv = 1

    " Don't autofold code
    let g:pymode_folding = 0
else
    let g:pymode_lint = 0
    let g:pymode_virtualenv = 0
endif


" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = 'b'
" End Python-mode----------------------------------------------------

" hi EOLWhitespace ctermbg=red
" match EOLWhitespace /\s\+$/

" Use ,l to toggle display of whitespace
" Don't map L as it is a standard motion key (LOW)
set list!
nnoremap <localleader>l :set list!<cr>
" And set some nice chars to do it with
" set listchars=tab:»\ ,eol:¬,trail:-
set listchars=tab:»-,trail:\ ,eol:¬
" Specialkey is used for highlighing 'trail' above
" see :help listchars
hi Specialkey ctermbg=red
hi NonText ctermfg=blue
" automatically change window's cwd to file's dir
set autochdir
" I prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab
" Settings for yaml files .ansible is added for ansible-lint
augroup ansible-lint
    autocmd!
    autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml.ansible foldmethod=manual
    autocmd FileType yaml.ansible setlocal ts=2 sts=2 sw=2 expandtab
augroup END

augroup dotabs
    autocmd!
    autocmd BufNewFile,BufReadPost .gitconfig set filetype=gitconfig foldmethod=manual
    autocmd FileType gitconfig setlocal ts=4 sts=4 sw=4 noexpandtab
augroup END

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
    endif

" Change default behavior of 'gf' Goto File to split mode instead of current
" window
 nnoremap gf <C-W>f
 vnoremap gf <C-W>f
