" use filetype on
filetype plugin indent on
" use syntax on
syntax on
" show possible command suggestions
set showcmd
" use vim defaults
set nocompatible
" allways show status line
set ls=2
" numbers of spaces of tab character
set tabstop=4
" convert tabs to spaces
set expandtab
" numbers of spaces to autoindent
set shiftwidth=4
" keep 3 lines when scrolling
set scrolloff=3
" display incomplete commands
set showcmd
" highlight searches
set hlsearch
" do incremental searching
set incsearch
" show the cursor position all the time
set ruler
" turn off error beep/flash
set visualbell t_vb=
" turn off visual bell
set novisualbell
" do not keep a backup file
set nobackup
" show line numbers
set number
" ignore case when searching
set ignorecase
" show title in console title bar
set title
" smoother changes
set ttyfast
" last lines in document sets vim mode
set modeline
" number lines checked for modelines
set modelines=3
" Abbreviate messages
set shortmess=atI
" dont jump to first character when paging
set nostartofline
" move freely between files
set whichwrap=b,s,h,l,<,>,[,]
" always set autoindenting on
set autoindent
" smart indent
set smartindent
" no c-indent
set nocindent
" toggle raw past
set pastetoggle=<F2>
" show mode
set showmode
" set mode to xterm (helps with screen)
set term=xterm-256color
" set colorscheme
colorscheme ir_black

" map K to split lines
:nnoremap K i<CR><Esc>
" press F4 to toggle highlighting on/off.
:noremap <F4> :noh<CR>
" press F2 to save a file opened in RO mode
:noremap <F2> :w ! sudo tee %<CR>
" press Ctrl+Left , Ctrl+Right to switch tabs
nnoremap <F3> :set invpaste paste?<CR>
" switching between tabs
:map <C-Left> :tabp<CR>
:map <C-Right> :tabn<CR>