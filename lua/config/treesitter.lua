require'nvim-treesitter.configs'.setup({
    highlight={enable=true},
    indent={enable=true},
    rainbow={enable=true},
    --pairs={enable=true,highlight_pair_events={'CursorMoved'}}, --TODO
    context_commentstring={enable=true},
    refactor={
        smart_rename={enable=true,keymaps={smart_rename="gR"}},
        --navigation={enable=true,keymaps={goto_definition_lsp_fallback='gd'}}
    },
    playground={enable=true},
    endwise={enable=true},
})
function _G.TSUpadte()
    require'nvim-treesitter.configs'.setup({
        ensure_installed={
            'python','lua','fish',
            'bash','vim',
            --
            'go','c','html','c_sharp',
            'java','javascript','css',
            'cpp','rust','typescript',
            'haskell','fennel','commonlisp',
            'llvm','tlaplus',
            --
            'vimdoc','org','markdown',
            'json','toml','hjson',
            'jsonc','norg','jsdoc',
            'json5','rst','todotxt',
            'markdown_inline',
            --
            'comment','regex','query',
        }})
    require'nvim-treesitter.install'.commands.TSUpdate['run']()
end
vim.api.nvim_create_user_command('TSUpadte',':lua _G.TSUpadte()\r',{})
