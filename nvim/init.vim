"Gotta be first
set nocompatible

" --- General Settings ---
set autoindent
set expandtab
set shiftround
set tabstop=4
set shiftwidth=4
set smarttab
set clipboard=unnamed
set mouse=a

set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch

syntax on

" Training Wheels
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Tab Switching
nnoremap <C-j> :tabp<CR>
nnoremap <C-k> :tabn<CR>
nnoremap <C-n> :tabnew<CR>

" lol
noremap ; :


" =====[PLUGIN MANAGER STUFF]=======
" Directory for plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'zhou13/vim-easyescape'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
Plug 'antiagainst/vim-tablegen'

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'othree/html5.vim'

" Svelte
Plug 'evanleck/vim-svelte'

" Initialize plugin system
call plug#end()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Syntastic Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Set lightline
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'component': {
    \     'cocstatus': '%{coc#status()}',
    \     'charhexvalue': '0x%B',
    \     'gitbranch': ' %{fugitive#head()}'
    \ },
    \ 'active': {
    \   'left': [
    \             ['mode', 'paste'],
    \             [ 'readonly', 'gitbranch', 'filename', 'modified', 'hexcharstaus']
    \         ]
    \     },
    \ 'component_function': { 'gitbranch': 'FugitiveHead' }
    \ }

colorscheme gruvbox
set termguicolors
" hi Normal guibg=NONE ctermbg=NONE

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
