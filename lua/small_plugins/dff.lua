local M={}
function M._create_repeat(list,x,nmin,nmax)
    local ret={}
    local n=nmin
    while n<=nmax do
        local i=list[n]:sub(1,x)
        local count=0
        local nm=n
        while list[n]:sub(1,x)==i do
            count=count+1
            n=n+1
            if n>#list then break end
        end
        if count>1 then
            ret[i]=count
            ret=vim.tbl_extend('force',ret,M._create_repeat(list,x+1,nm,n-1))
        end
    end
    return ret
end
function M.create_repeat(list)
    return M._create_repeat(list,1,1,#list)
end
function M.objectify(list)
    local ret={}
    local rep=M.create_repeat(list)
    for _,i in pairs(list) do
        local hig={}
        local c=-1
        local text=''
        local search=''
        for j in (i:gsub('\r','/')..'\r'):gmatch('.') do
            text=text..j
            if not rep[text] then
                table.insert(hig,2)
                table.insert(ret,{i,hig,search..j})
                break
            end
            if rep[text]==c then
                table.insert(hig,1)
            else
                table.insert(hig,2)
                search=search..j
            end
            c=rep[text]
        end
    end
    return ret
end
function M.parse(items)
    if #items==1 then
        local item=items[1]
        local hig=vim.fn['repeat']({1},#item-1)
        table.insert(hig,2)
        return {{item,hig,item:sub(1,1)}}
    end
    return M.objectify(items)
end
function M.create_text(parsed,search,path)
    return vim.iter(parsed)
        :filter(function (v) return vim.startswith(v[3],search) end)
        :map(function (v)
            return (vim.fn.isdirectory(path..'/'..v[1])==1 and '/' or ' ')
                ..v[1]:gsub('\n','\r')
                ..(vim.endswith(v[3],'\r') and '\r' or '')
        end)
        :totable()
end
function M.mainloop(buf,path)
    local search=''
    while vim.fn.isdirectory(path)==1 do
        local parsed=M.parse(vim.fn.readdir(path))
        local indexdict=vim.iter(parsed):fold({},function(t,i) t[i[3]]=i[1] return t end)
        local text=M.create_text(parsed,search,path)
        vim.api.nvim_buf_set_lines(buf,0,-1,false,text)
        vim.api.nvim_buf_set_lines(buf,-1,-1,false,{'',vim.fn.pathshorten(path,2):gsub('\n','\r')..' :'..search})
        vim.cmd.redraw()
        local char=vim.fn.getcharstr()
        if char=='' then
            return path
        elseif char=='\x80kb' then
            if search=='' then
                path=vim.fs.dirname(path)
            else
                search=search:sub(0,-2)
            end
        else
            search=search..char
        end
        if indexdict[search] then
            path=path..'/'..indexdict[search]
            search=''
        end
    end
    return path
end
function M.dff()
    local buf=vim.api.nvim_create_buf(false,true)
    local window=vim.api.nvim_get_current_win()
    vim.api.nvim_buf_set_option(buf,"bufhidden","wipe")
    vim.api.nvim_win_set_buf(window,buf)
    vim.cmd.edit(M.mainloop(0,vim.fn.expand('#:p:h')))
end
function M.setup()
    vim.api.nvim_create_user_command('Dff',M.dff,{})
end
return M
--[[ TODO:
main.h
main.c
lib/
>> c >>
main.c
-- If char not in next_possible_chars then go_deeper()
--]]
