" Bootstrap vim-plug
silent ![ -e ~/.vim/autoload/plug.vim ] || fetch -q -o ~/.vim/autoload https://github.com/junegunn/vim-plug/raw/master/plug.vim

call plug#begin('~/.config/nvim/plugged')

" color schemes
Plug 'cocopon/iceberg.vim'

" tree-sitter
Plug 'nvim-treesitter/nvim-treesitter'

" lsp-config
Plug 'neovim/nvim-lspconfig'

" completion
" Plug 'nvim-lua/completion-nvim' " bug for nvim >0.5, no longer maintained
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" scratch buffer
Plug 'mtth/scratch.vim'

" paren/brace/bracket text objects with mappings
Plug 'tpope/vim-surround'

" netrw replacement with lf
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'

" git support
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'
Plug 'nvim-lua/plenary.nvim'
Plug 'TimUntersberger/neogit'

" hashicorp config language
Plug 'jvirtanen/vim-hcl'

" vale prose linter
Plug 'jose-elias-alvarez/null-ls.nvim'


Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tsony-tsonev/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'ryanoasis/vim-devicons'

call plug#end()

lua <<EOF
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.vale,
    },
})
EOF

" NETDtree
let g:NERDTreeGitStatusWithFlags = 1
nmap <C-n> :NERDTreeToggle<CR>

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction



" colorscheme
colorscheme iceberg

set number                                   " always show line numbers
set numberwidth=2                            " reduce min number width to 2
set mouse=a                                  " support mouse everywhere
set shiftround                               " round > and < commands to nearest tabstop
set updatetime=200                           " shorter update time
set shortmess+=c                             " don't show |ins-completion-menu| messages
set signcolumn=yes                           " always show the signcolumn
set wildignore+=*.pyc,*.sw?,*/.mypy_cache/*  " patterns to skip in glob matching
set completeopt=noselect,menuone             " customize the completion menu
"set inccommand=nosplit                       " incrementally show the impact of commands as we type

" pre-populate the \v modifier in search regexps, and
" re-implement * and # to prefix \v in the search pattern
nnoremap / /\v
nnoremap ? ?\v
nnoremap * :<c-u>execute "normal! /\\v<" . expand("<cword>") . ">\<lt>cr>"<cr>
nnoremap # :<c-u>execute "normal! ?\\v<" . expand("<cword>") . ">\<lt>cr>"<cr>

" shortcut to clear search highlight
nmap <leader>n :nohlsearch<cr>

" shortcut to refresh the current buffer
nmap <leader>e <cmd>e!<cr>

" shortcut open bash terminals
nmap <leader>bb <cmd>e term://bash<cr>
nmap <leader>bt <cmd>tabe term://bash<cr>
nmap <leader>bs <cmd>split term://bash<cr>
nmap <leader>bv <cmd>vsplit term://bash<cr>

" grep for the word under cursor
nnoremap <leader>g :<c-u>grep '\b<cword>\b'<cr>

" map \ac (apostrophe comma) to wrap a buffer's lines in single quotes and add
" commas to the ends
nnoremap <leader>ac :<c-u>g/^$/d<cr>:%s/^.*$/'\0',/<cr>:nohlsearch<cr>G$xgg0

" quickfix, locationlist
nnoremap <leader>qo :copen<cr>
nnoremap <leader>qc :cclose<cr>
nnoremap <leader>qn :cnext<cr>
nnoremap <leader>qp :cprevious<cr>
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>lc :lclose<cr>
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>

" escape pane-moving commands in terminal mode
tnoremap <C-w>h <C-\><C-n><C-w>h<cmd>FloatermHide default<cr>
tnoremap <C-w>j <C-\><C-n><C-w>j<cmd>FloatermHide default<cr>
tnoremap <C-w>k <C-\><C-n><C-w>k<cmd>FloatermHide default<cr>
tnoremap <C-w>l <C-\><C-n><C-w>l<cmd>FloatermHide default<cr>

" fzf
nnoremap <C-p> <cmd>Files<cr>
nnoremap <C-b> <cmd>Buffers<cr>
nnoremap <C-f> <cmd>:Rg<cr>

" floaterm
nnoremap <leader>ft <cmd>FloatermToggle default<cr>

" lf
let g:lf_map_keys = 0
let g:lf_replace_netrw = 1
nnoremap - <cmd>Lf<cr>

augroup LastKnownCursor
    autocmd!

    " jump to last known cursor position when opening a file
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \     execute "normal! g`\"" |
        \ endif
augroup END

augroup Python
    autocmd!

    " python shortcuts:
    " \t to run the current test file
    " \i to run an interactive ipython shell with the current file
    " \I to run 'python setup.py install'
    autocmd FileType python
        \ nnoremap <buffer> <leader>t :<c-u>execute "w\|split +term\\ python3\\ -m\\ nose\\ -v\\ %"<cr>
    autocmd FileType python
        \ nnoremap <buffer> <leader>i :<c-u>execute "w\|split +term\\ ipython3\\ -i\\ %"<cr>
    autocmd FileType python
        \ nnoremap <buffer> <leader>I :<c-u>execute "w\|split +term\\ python3\\ setup.py\\ install"<cr>

    " open all folds upon opening a python file
    autocmd FileType python normal zR
augroup END

augroup Typescript
    autocmd FileType typescript setlocal expandtab
    autocmd FileType typescript setlocal tabstop=2
    autocmd FileType typescript setlocal shiftwidth=2
    autocmd FileType typescript setlocal softtabstop=-1
augroup END

augroup Zig
    autocmd FileType zig setlocal expandtab
    autocmd FileType zig setlocal tabstop=4
    autocmd FileType zig setlocal shiftwidth=4
    autocmd FileType zig setlocal softtabstop=-1
augroup END

command! -nargs=1 Tabs setlocal noet ts=<args> sw=<args> sts=-1
command! -nargs=1 Spaces setlocal et ts=<args> sw=<args> sts=-1

command! Fdiff normal /\<{7}
nnoremap <leader>d <cmd>Fdiff<cr>



"
" neogit
"

lua <<EOF
require('neogit').setup {}
EOF



"
" tree-sitter
"

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"go", "python"},
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=9999999



"
" lsp
"

lua <<EOF

-- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<c-d>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<c-g>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<c-\\>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>i', '<cmd>lua goimports(1000)<CR>', opts)

--  require('completion').on_attach()

  vim.api.nvim_exec([[
    hi LspReferenceRead cterm=bold ctermbg=DarkGray guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=DarkGray guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=DarkGray guibg=LightYellow
    augroup lsp_setup
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()
      autocmd BufWritePre <buffer> lua goimports(1000)
    augroup END
  ]], false)
end

function goimports(timeout_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { source = { organizeImports = true } }

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local k, v = next(result)
  local actions = v.result
  if not actions then return end
  local k, action = next(actions)

  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

local servers = { "gopls", "elmls" }

function lspsetup()
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
  end
end

lspsetup()
EOF

nnoremap <leader>l <cmd>lua lspsetup()<cr>



"
" Git shortcuts
"

" git status and merginal shortcuts
nnoremap <silent> <leader>s  :<c-u>Git<cr>
nnoremap <silent> <leader>m  :<c-u>Merginal<cr>

" neogit mappings
nnoremap <silent> <leader><leader>g <cmd>Neogit kind=split<cr>
nnoremap <silent> <leader><leader>t <cmd>Neogit kind=tab<cr>
nnoremap <silent> <leader><leader>b <cmd>Neogit branch<cr>
nnoremap <silent> <leader><leader>c <cmd>Neogit commit<cr>
nnoremap <silent> <leader><leader>l <cmd>Neogit log<cr>


"
" FZF and RipGrep
"

" set grep program to ripgrep
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" don't search for filename with rg
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)


" vim: ft=vim
