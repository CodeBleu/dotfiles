" ------------------------------ Settings ------------------------------{{{

set encoding=utf-8
set splitright
set hidden
set colorcolumn=0
" allow colors to work for powerline"
set t_Co=256
"allow backspace to remove all spaces of 'tab'"
set softtabstop=4
set nocompatible
" Add your private snippet path to runtimepath
set runtimepath^=~/dotfiles
" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
set list!
" automatically change window's cwd to file's dir
set autochdir
" I prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab
set wildmenu
set wildmode=longest,full
set foldmethod=marker
set nofoldenable
set incsearch
set hlsearch
" Try to only save folds for makeview and not
" cause issues by saving stuff that causes issues
" with other plugins --
" https://stackoverflow.com/questions/26917336/vim-specific-mkview-and-loadview-in-order-to-avoid-issues
set viewoptions-=options
set sessionoptions-=options
" -------------------------

scriptencoding utf-8
let mapleader = ' '
let maplocalleader = ','

augroup manualfolding
    " set folding type to manual for these files
    autocmd!
    autocmd FileType terraform setlocal foldmethod=manual
augroup END

augroup AutoSaveGroup
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

augroup spelling
    " set spell on filetypes that it matters
    autocmd!
    autocmd FileType gitcommit setlocal spell
    autocmd FileType markdown setlocal spell
augroup END

" Needed for javacomplete2
augroup javacomplete2
    autocmd!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup END

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

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

" Read-only odt/odp through odt2txt
augroup odt2txt
    autocmd!
    autocmd BufReadPre *.odt,*.odp silent set ro
    autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"
augroup END

" more subtle popup colors
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold
endif

" }}}

" ------------------------------ Mappings ------------------------------{{{

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
nnoremap <localleader>sb :call Scratch()<cr>
nnoremap <localleader>cc :call ColorColumn()<cr>
" Remapped highlight search. <F4> is used in vimspector by default
noremap <localleader>hl :set hlsearch! hlsearch?<cr>
nnoremap <localleader>es :UltiSnipsEdit<cr>
" quickfix navigation
" Next quickfix
nnoremap cn :cn<cr>
" Previous quickfix
nnoremap cp :cp<cr>
" :Commits remap FZF
nnoremap <localleader>gc :Commits<cr>
" buffer navigation
" Next buffer
nnoremap bn :bn<cr>
" Previous buffer
nnoremap bp :bp<cr>
" Buffer list FZF
nnoremap bl :Buffers<cr>
" Buffer Lines (current buffer)
nnoremap <localleader>bl :BLines<cr>
" Buffer Lines (All buffers)
nnoremap <localleader>al :Lines<cr>
" Save all buffers
nnoremap bua :b update<cr>
" disable <esc> key and remap to 'kj'
inoremap <esc> <nop>
inoremap kj <esc>
"disable arrow keys - force learn hjkl"
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
" Use ,l to toggle display of whitespace
" Don't map L as it is a standard motion key (LOW)
nnoremap <localleader>l :set list!<cr>
" Change default behavior of 'gf' Goto File to split mode instead of current
" window
nnoremap gf <C-W>f
vnoremap gf <C-W>f
nmap <localleader>x :!xdg-open %<cr><cr>
nnoremap <localleader>gf :GitGutterFold<cr>
" map Ctrl-P to use FZF"
nnoremap <C-p> :GFiles <Cr>
nnoremap <leader>q :Rg<CR>

"}}}

" ------------------------------ Functions/misc ------------------------------{{{

" Toggle set paste/set nopaste
set pastetoggle=<F5>

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" end Toggle set paste/set nopaste

function! Scratch()
    split
    resize 10
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted
endfunction

function! ColorColumn()
    if(&colorcolumn == 0)
        set colorcolumn=80
    else
        set colorcolumn=0
    endif
endfunc
"}}}

" ------------------------------ Version Specific ------------------------------{{{

if v:version >= 703

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
"}}}

" ------------------------------ Plugins ------------------------------{{{

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
Plug 'vimwiki/vimwiki'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase'}
Plug 'jremmen/vim-ripgrep'
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
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
Plug 'airblade/vim-gitgutter'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'vim-test/vim-test'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
"}}}

" ------------------------------ Plugins: Settings ------------------------------{{{

nnoremap <localleader>tn :TestNearest<CR>
nnoremap <localleader>tf :TestFile<CR>
nnoremap <localleader>ts :TestSuite<CR>
nnoremap <localleader>tl :TestLast<CR>
nnoremap <localleader>tv :TestVisit<CR>

" And set some nice chars to do it with
" set listchars=tab:»\ ,eol:¬,trail:-
set listchars=tab:»-,trail:\ ,eol:¬

" Our personal snippets go into ~/dotfiles/vim_user_snippets.
" By defining the below, it opens new file at this location.
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit='~/dotfiles/vim_user_snippets'
" Open UltiSnipEdit in split window
let g:UltiSnipsEditSplit='vertical'
" Change <tab> for Ultisnips so it will work in vimwiki tables
let g:UltiSnipsExpandTrigger='<c-p>'
let g:UltiSnipsListSnippets='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-l>'
let g:UltiSnipsJumpBackwardTrigger='<c-h>'
" When vim starts, Ultisnips tries to find snippet directories defined below, under the paths in runtimepath.
let g:UltiSnipsSnippetDirectories=[ 'UltiSnips', 'vim_user_snippets']

let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline_left_sep = "\uE0b4"
let g:airline_right_sep = "\ue0b6"
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

" Terraform vim plugin config
let g:terraform_fmt_on_save=1
let g:terraform_align=1

" Change Folded colors for PaperColor theme
let g:PaperColor_Theme_Options = {
            \ 'theme': {
            \   'default.dark': {
            \     'override' : {
            \       'folded_bg': ['#5fafd7', '74'],
            \       'folded_fg': ['#000000', '16']
            \       }
            \    }
            \  }
            \}

if $TERM ==# 'xterm-256color'
    set termguicolors
endif

" Color settings applied after Solarized Plugin loaded
" change theme to easier reading "
set background=dark
colorscheme PaperColor

" Color settings applied colorscheme set
" Specialkey is used for highlighing 'trail'
" see :help listchars
if $TERM ==# 'xterm-256color'
    hi SpecialKey guibg=red
else
    hi SpecialKey ctermbg=red
endif


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
    " FOR Markdown formatting
    let g:vimwiki_global_ext = 0
    let g:vimwiki_folding = 'syntax:quick'
    let g:vimwiki_list = [{'path': '~/vimwiki',
                          \ 'syntax': 'markdown', 'ext': '.md'}]
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

" ------------------------------ Python-mode ------------------------------{{{
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
" End Python-mode----------------------------------------------------}}}
