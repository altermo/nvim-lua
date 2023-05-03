local M={}
M.builders={
    python={normal='python %s',source='pyfile %'},
    fish={normal='fish %s'},
    lua={normal='lua %s',source='luafile %'},
    fennel={normal='fennel %s',source='lua dofile("/usr/share/lua/5.4/fennel.lua").dofile(vim.fn.expand("%"))'},
    cs={normal='csharp %s'},
    rust={normal='rustc %s -o __tmp;./__tmp;rm __tmp'},
    cpp={normal='zig c++ -O2 %s -o __tmp;./__tmp;rm __tmp'},
    c={normal='zig cc -O2 %s -o __tmp;./__tmp;rm __tmp'},
    vim={source='so %'},
    zig={normal='zig run %s'},
}
function M.eval()
    vim.cmd('silent! update')
    local ft=vim.o.filetype
    local builder=M.builders[ft]
    if not builder or not builder.source then
        M.deferr(ft)
        return
    end
    vim.cmd(builder.source)
end
function M.build()
    vim.cmd('silent! update')
    local ft=vim.o.filetype
    local builder=M.builders[ft]
    if not builder or not builder.normal then
        M.deferr(ft)
        return
    end
    vim.cmd('AsyncRun '..builder.normal:format('"%"'))
end
function M.termbuild()
    vim.cmd('silent! update')
    local ft=vim.o.filetype
    local builder=M.builders[ft]
    if not builder or not builder.normal then
        M.deferr(ft)
        return
    end
    vim.cmd.vnew()
    vim.fn.termopen(builder.normal:format(vim.fn.expand('#:p')))
    vim.cmd.startinsert()
end
function M.deferr(ft)
    vim.notify("Builderror: filetype "..ft.." has no builder or can not be built")
end
function M.setup()
    local nno=require'utils.keymap'.nno
    nno("“",M.build)
    nno("‘",M.termbuild)
    nno("<F5>",M.build)
    nno("<F6>",M.eval)
    nno("<F7>",M.termbuild)
    nno("<F8>",function () M.builders[vim.o.filetype].normal=vim.fn.input(':') end)
end
return M
