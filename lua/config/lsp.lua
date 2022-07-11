require'nvim-lsp-installer'.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.sumneko_lua.setup{settings={Lua={diagnostics={globals={'vim','unpack'}}}}}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.clangd.setup{}
vim.keymap.set('n','[d',vim.diagnostic.goto_prev,{noremap=true,silent=true})
vim.keymap.set('n',']d',vim.diagnostic.goto_next,{noremap=true,silent=true})
