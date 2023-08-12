local M={}
M.options={
    r={
        desc='ranger',
        action=function() require'small_plugins.ranger'.ranger(vim.fn.bufname('#')) end,
    },
    t={
        desc='terminal',
        action=vim.cmd.terminal,
    },
    f={
        desc='shell',
        action=vim.cmd.Shell,
    },
    ['*']={
        desc='nothing',
        action=function() vim.cmd.buffer('#') end,
    },
    q={
        desc='quit',
        action=vim.cmd.quit,
    },
    s={
        desc='scratch',
        action=function ()
            local buf=vim.api.nvim_create_buf(true,true)
            vim.api.nvim_buf_set_option(buf,'bufhidden','wipe')
            vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(),buf)
        end
    },
    a={
        desc='find',
        action=function()
            require("utils.lib").termrun('fish -ic fsf')
        end
    },
    d={
        desc='dff',
        action=function ()
            vim.cmd.bdelete()
            vim.cmd.vnew()
            require'small_plugins.dff'.dff()
        end,
    },
}
function M.open(Iwin)
    local c=vim.fn.getpos('.')
    local buf=vim.api.nvim_create_buf(false,true)
    vim.api.nvim_buf_set_option(buf,'bufhidden','wipe')
    local win=Iwin or vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win,buf)
    for k,v in pairs(M.options) do
        vim.api.nvim_buf_set_lines(buf,0,0,false,{k..' : '..v.desc})
    end
    vim.cmd.redraw()
    local char=vim.fn.getcharstr()
    if M.options[char] then
        M.options[char].action()
    else
        vim.cmd.buffer('#')
        vim.fn.setpos('.',c)
        vim.api.nvim_feedkeys(char,'m',true)
    end
end
function M.vsplit()
    vim.cmd.vsplit()
    M.open()
end
function M.split()
    vim.cmd.split()
    M.open()
end
return M
