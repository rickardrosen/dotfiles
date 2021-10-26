" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

packadd nvim-treesitter
packadd nvim-lspconfig
lua <<EOF
  local nvim_lsp = require('lspconfig')
  local custom_attach = function(client)
    print("LSP started");
    require'completion'.on_attach(client)
    -- Mappings.
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', 'Ö', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', 'Ä', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  end

  vim.lsp.set_log_level(0)

  require'nvim-treesitter.configs'.setup {
    ensure_installed = "typescript",     -- one of "all", "language", or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
      disable = { },  -- list of language that will be disabled
    },
  }
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    --snippet = {
    --  expand = function(args)
    --    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    --    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    --    -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    --  end,
    --},
    mapping = {
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
    cmp.select_next_item()
        else
    fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
    cmp.select_prev_item()
        else
    fallback()
        end
      end,
    },
    --mapping = {
    --  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --  ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --  ['<C-Space>'] = cmp.mapping.complete(),
    --  ['<C-e>'] = cmp.mapping.close(),
    --  ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
    --  ['<CR>'] = cmp.mapping.confirm({ select = true }),
    --},
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  nvim_lsp.tsserver.setup {
    on_attach=custom_attach;
    capabilities = capabilities;
    flags = {
        debounce_text_changes = 150,
    };
    filetypes = { "typescript" }
  }

  nvim_lsp.terraformls.setup{
    on_attach=custom_attach;
    capabilities = capabilities;
    flags = {
        debounce_text_changes = 150,
    };
    filetypes = { "tf" };
    cmd = {'terraform-ls', 'serve'}
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

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
"let g:compe = {}
"let g:compe.enabled = v:true
"let g:compe.autocomplete = v:true
"let g:compe.debug = v:false
"let g:compe.min_length = 1
"let g:compe.preselect = 'enable'
"let g:compe.throttle_time = 80
"let g:compe.source_timeout = 200
"let g:compe.resolve_timeout = 800
"let g:compe.incomplete_delay = 400
"let g:compe.max_abbr_width = 100
"let g:compe.max_kind_width = 100
"let g:compe.max_menu_width = 100
"let g:compe.documentation = v:true
"
"let g:compe.source = {}
"let g:compe.source.path = v:true
"let g:compe.source.buffer = v:true
"let g:compe.source.calc = v:true
"let g:compe.source.nvim_lsp = v:true
"let g:compe.source.nvim_lua = v:true
"let g:compe.source.vsnip = v:true
"let g:compe.source.ultisnips = v:true
"let g:compe.source.luasnip = v:true
"let g:compe.source.emoji = v:true

packadd vim-airline
packadd gruvbox-material
" packadd vim-airline-themes
set rtp+=/run/current-system/sw/bin/fzf
packadd fzf
packadd fzf.vim

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

  " Tabline
let mapleader = " "
"map <Space> <Leader>
nnoremap <Leader><Leader> :GFiles<CR>
nnoremap <C-F> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>m :Marks<CR>
"nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>g :Rg<CR>
nnoremap ö {
nnoremap ä }
nnoremap Ö [
nnoremap Ä ]
"remap the p command in visual mode so that it first deletes to the black hole register 
" xnoremap <leader>p "_dP
"

augroup prettier_save
  au!
  au FileType javascript,typescript,typescriptreact,json nnoremap <buffer> <Leader>wf :Prettier<CR>:w<CR>
augroup END

augroup tf_save
  au!
  au FileType tf nnoremap <buffer> <Leader>wf :w<CR>:!terraform fmt<CR>:e<CR>
augroup END

autocmd bufwritepost *.tf silent !terraform fmt
