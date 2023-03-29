local set=vim.opt
set.shiftwidth=4
set.tabstop=4
set.softtabstop=4
set.smartindent=true
set.breakindent=true
set.cindent=true
set.expandtab=true
set.linebreak=true
set.fillchars='vert: ,eob: '
set.foldmethod='expr'
set.foldexpr='v:lua.Fold(v:lnum)'
set.foldenable=false
set.relativenumber=true
set.number=true
set.numberwidth=2
set.splitbelow=true
set.splitright=true
set.showbreak='↳ '
set.list=true
set.ignorecase=true
set.smartcase=true
if tonumber(os.date('%H'))<8 or tonumber(os.date('%H'))>=16 then
    set.background='dark'
else
    set.background='light'
end
set.termguicolors=true
set.colorcolumn='1,41,81,121,161,201,241'
set.cursorline=true
set.undofile=true
set.swapfile=false
set.synmaxcol=1000
set.pumblend=10
set.history=1000
set.scrolloff=5
set.winminheight=0
set.textwidth=0
set.timeoutlen=500
set.spelllang='sv'
set.shortmess='aToOAFW'
set.completeopt='menu,menuone,noselect'
set.virtualedit='block,onemore'
set.nrformats='bin,hex,alpha'
set.path:append('**')
set.lazyredraw=true
set.showmode=false
set.modelineexpr=true
set.statuscolumn = "%C%s%=%{v:virtnum>0?'':v:relnum?v:relnum:v:lnum}"
--set.shell='/bin/bash'
