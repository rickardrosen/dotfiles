" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'sainnhe/gruvbox-material'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

lua <<EOF
  require('telescope')
  require('lsp')
  require('treesitter')
  require('cmp_setup')
  vim.g.markdown_fenced_languages = {
  "ts=typescript"
  }
EOF

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

set termguicolors
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set expandtab
set hidden
set number
set cursorline
set cmdheight=2
set updatetime=300
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
set mouse=r
set scrolloff=20
set nobackup
set nowritebackup
" Avoid showing message extra message when using completion
set shortmess+=c
set signcolumn=number
" set background=dark
"
" Display tabs and trailing spaces visually
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
set list listchars=tab:\ \ ,trail:·

" Nix path to fzf
set rtp+=/run/current-system/sw/bin/fzf

let g:airline#extensions#tabline#enabled = 1           " enable airline tabline
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
"let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (clear it so nothing is shown)
"let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (clear it so nothing is shown)
let g:airline#extensions#tabline#fnamemod = ':t'       " disable file paths in the tab
"let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right
"let g:airline#extensions#tabline#show_buffers = 1      " dont show buffers in the tabline
"let g:airline#extensions#tabline#tab_min_count = 2     " minimum of 2 tabs needed to display the tabline
let g:airline#extensions#tabline#show_splits = 1       " disables the buffer name that displays on the right of the tabline
let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers
let g:airline#extensions#tabline#show_tab_type = 1     " disables the weird ornage arrow on the tabline
let g:airline#extensions#tabline#fnamecollapse = 1

"colorscheme solarized
let g:gruvbox_material_background = 'soft'
" autocmd vimenter * colorscheme gruvbox-material
colorscheme gruvbox-material
let g:airline_theme='gruvbox_material'

let mapleader = " "
nnoremap <Leader><Leader> :GFiles<CR>
nnoremap <C-F> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>m :Marks<CR>
"nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>g :Rg<CR>
nnoremap <leader>x :bw<CR>
nnoremap ö {
nnoremap ä }
nnoremap Ö [
nnoremap Ä ]
"remap the p command in visual mode so that it first deletes to the black hole register 
" xnoremap <leader>p "_dP
"

" terminal emulator
"""""""""""""""
"tnoremap <Esc> <C-\><C-n>
"tnoremap <Esc> <C-\><C-n>?\$<CR>
" Move between windows
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

augroup prettier_save
  au!
  au FileType javascript,typescript,typescriptreact,json nnoremap <buffer> <Leader>wf :Prettier<CR>:w<CR>
augroup END

augroup tf_save
  au!
  au FileType tf nnoremap <buffer> <Leader>wf :w<CR>:!terraform fmt<CR>:e<CR>
augroup END

autocmd bufwritepost *.tf silent !terraform fmt

