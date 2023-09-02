local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end
  vim.opt.rtp:prepend(pckr_path)
end
bootstrap_pckr()
local function get_rplugin()
  return function()
    if vim.g.loaded_remote_plugins==1 then
      vim.g.loaded_remote_plugins=nil
      vim.cmd.source('/usr/share/nvim/runtime/plugin/rplugin.vim')
    end
  end
end
local function lcmd(cmds,header)
  return function (load)
    for _,v in ipairs(cmds) do
      vim.api.nvim_create_user_command((header or '')..v,function (args)
        load()
        vim.cmd(((header or '')..v)..' '..args.args)
      end,{nargs='*',bang=true}) end end end
local function lkey(mkeys)
  return function (load)
    for mode,keys in pairs(mkeys) do
      for _,key in ipairs(keys) do
        vim.api.nvim_set_keymap(mode,key,'',{callback=function()
          load()
          vim.api.nvim_input(key)
        end}) end end end end
local function levent(events)
  return function (load)
    vim.api.nvim_create_autocmd(events,{callback=load,once=true})
  end end
local function lft(fts)
  return function (load)
    vim.api.nvim_create_autocmd('FileType',{pattern=fts,callback=load,once=true})
  end
end
local function ll(load) vim.api.nvim_create_autocmd('User s1',{callback=load,once=true}) end
local function get_setup(name,conf) return function () require(name).setup(conf) end end
local function get_config(name) return function () require('config.'..name) end end
require('pckr').add{
  {'altermo/ultimate-autopair.nvim',cond=function() end,branch='v0.6'},

  ----colorschm
  'folke/tokyonight.nvim',
  'ray-x/starry.nvim',
  'edeneast/nightfox.nvim',
  'projekt0n/github-nvim-theme',
  'bluz71/vim-nightfly-colors',
  'matsuuu/pinkmare',
  'lifepillar/vim-gruvbox8',
  'NTBBloodbath/doom-one.nvim',
  'hoprr/calvera-dark.nvim',

  ----visual
  {'folke/twilight.nvim',cond=lcmd{'Twilight'}},
  {'rrethy/vim-hexokinase',run='make hexokinase',cond=function (load)
    vim.g.Hexokinase_highlighters={'backgroundfull'}
    ll(load) end},
  {'anuvyklack/pretty-fold.nvim',cond=ll,config=get_setup'pretty-fold'},
  {'shellraining/hlchunk.nvim',config=get_setup('hlchunk',{
    indent={chars={'│'}},
    chunk={enable=false},
    blank={enable=false},
    line_num={enable=false},
  }),cond=ll},
  {'chentoast/marks.nvim',config=get_setup'marks',cond=lkey{n={'m','dm'}}},
  {'smjonas/live-command.nvim',config=get_setup('live-command',{commands={Norm={cmd='norm!'},G={cmd='g'},V={cmd='v'}}})},
  {'nvim-lualine/lualine.nvim',config=get_setup'lualine',cond=ll},
  {'folke/which-key.nvim',config=get_config'which-key'},

  ----keys
  {'ecthelionvi/neoswap.nvim',config=function()
    require('NeoSwap').setup{}
    local nno=require'utils.keymap'.nno
    nno('>w','<cmd>NeoSwapNext<cr>')
    nno('<w','<cmd>NeoSwapPrev<cr>')
  end},
  {'Exafunction/codeium.vim',cond=function(load) --https://github.com/Exafunction/codeium.vim/issues/118
    vim.g.codeium_disable_bindings=false
    vim.g.codeium_manual=true
    lkey({i={'<A-\'>'}})(load)
  end,config=function ()
      local ino=require 'utils.keymap'.ino
      local function wrapper(f,...)
        local args={...}
        return function() return f(unpack(args)) end
      end
      ino('<A-cr>',wrapper(vim.fn['codeium#Accept']),{expr=true})
      ino('<A-)>',wrapper(vim.fn['codeium#CycleCompletions'],1),{expr=true})
      ino('<A-(>',wrapper(vim.fn['codeium#CycleCompletions'],-1),{expr=true})
      ino('<A-\'>',wrapper(vim.fn['codeium#Complete']),{expr=true})
    end},
  {'tommcdo/vim-exchange',cond=lkey{n={'cx'},x={'X'}}},
  {'gbprod/yanky.nvim',config=function()
    require'yanky'.setup{}
    local k=require'utils.keymap'
    k.nno('p','<Plug>(YankyPutAfter)')
    k.nno('P','<Plug>(YankyPutBefore)')
    k.xno('p','<Plug>(YankyPutAfter)')
    k.xno('P','<Plug>(YankyPutBefore)')
    k.nno('<A-p>','<Plug>(YankyCycleForward)')
    k.nno('<A-P>','<Plug>(YankyCycleBackward)')
  end,cond=function (load)
      lkey({n={'p','P','<A-p>','<A-P>'},x={'p','P'}})(load)
      levent({'TextYankPost'})(load)
    end },
  {'monaqa/dial.nvim',config=function()
    local k=require'utils.keymap'
    local dialmap=require'dial.map'
    k.nno('<C-a>',dialmap.inc_normal())
    k.nno('<C-x>',dialmap.dec_normal())
    k.xno('<C-a>',dialmap.inc_visual())
    k.xno('<C-x>',dialmap.dec_visual())
  end,cond=lkey{n={'<C-a>','<C-x>'},x={'<C-a>','<C-x>'}}},

  ----movement
  {'mg979/vim-visual-multi',config=function() vim.g,VM_maps={} end,cond=lkey{n={'<C-n>','\\\\'},x={'<C-n>'}}},
  {'xiyaowong/accelerated-jk.nvim',config=function ()
    require('accelerated-jk').setup{}
    local xno=require'utils.keymap'.xno
    xno('j','<cmd>lua require"accelerated-jk".command("gj")\r')
    xno('k','<cmd>lua require"accelerated-jk".command("gk")\r')
  end,cond=lkey{n={'j','k'},x={'j','k'}}},
  {'folke/flash.nvim',config=get_config'flash'},

  ----command
  {'tobinpalmer/rayso.nvim',config=get_setup'rayso',cond=lcmd{'Rayso'}},
  {'kazhala/close-buffers.nvim',cond=lcmd{'BDelete','BWipeout'}},
  {'ckolkey/ts-node-action',config=function ()
    local tsaction=require('ts-node-action')
    tsaction.setup{}
    vim.keymap.set('n','K',tsaction.node_action)
  end,cond=lkey{n={'K'}},requires={'nvim-treesitter/nvim-treesitter'}},
  {'chrisgrieser/nvim-genghis',cond=lcmd{'NewFromSelection','Duplicate','Rename','Trash','Move','CopyFilename','CopyFilepath','Chmodx','New'}},
  {'krady21/compiler-explorer.nvim',cond=lcmd{'CECompile'}},
  {'stevearc/oil.nvim',config=function()
    local oil=require'oil'
    oil.setup{default_file_explorer=true,view_options={show_hidden=true}}
    vim.api.nvim_create_autocmd('BufWinEnter',{pattern='oil://*',callback=function (ev)
      vim.cmd.lcd(ev.file:sub(7))
    end})
  end},
  {'acksld/muren.nvim',config=get_setup'muren',cond=lcmd({'Toggle','Open','Close','Fresh','Unique'},'Moren')},
  {'cshuaimin/ssr.nvim',config=get_setup'ssr',requires={'nvim-treesitter/nvim-treesitter'}},
  {'smjonas/inc-rename.nvim',config=function()
    require'inc_rename'.setup{}
    require'utils.keymap'.nno('gr',':IncRename <C-r>=expand("<cword>")\r',{noremap=true})
  end,cond=function(load)
      lcmd{'IncRename'}(load)
      lkey{n={'gr'}}(load)
    end},
  {'nvim-colortils/colortils.nvim',cond=lcmd{'Colortils'},config=get_setup'colortils'},
  {'skywind3000/asyncrun.vim',cond=lcmd{'AsyncRun','AsyncStop'}},
  {'godlygeek/tabular',cond=lcmd{'Tabularize'}},
  --use{'jbyuki/instant.nvim',config=function () vim.g.instant_username='User' end},
  {'rraks/pyro',config=get_rplugin(),cond=function (load)
    vim.g.pyro_macro_path='/home/user/.macro'
    lcmd{'Pyro'}(load) end},

  ----sidepannel
  {'simnalamburt/vim-mundo',cond=lcmd{'MundoToggle'}},
  {'gorbit99/codewindow.nvim',config=function()
    local codewindow=require'codewindow'
    codewindow.setup()
    vim.api.nvim_create_user_command('CodeWindow',codewindow.toggle_minimap,{})
  end,cond=lcmd{'CodeWindow'}},

  ----search
  {'nvim-pack/nvim-spectre',config=function ()
    vim.api.nvim_create_user_command('Spectre',require'spectre'.open,{})
  end,requires={'nvim-lua/plenary.nvim'},cond=lcmd{'Spectre'}},
  ------telescope
  {'nvim-telescope/telescope.nvim',requires={
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-project.nvim',
    {'nvim-telescope/telescope-fzf-native.nvim',run='make'},
    'nvim-telescope/telescope-live-grep-args.nvim',
    {'nvim-telescope/telescope-ui-select.nvim',cond=function (load)
      ---@diagnostic disable-next-line: duplicate-set-field
      function vim.ui.select(...)
        load()
        local telescope=require'telescope'
        telescope.load_extension'ui-select'
        vim.ui.select(...)
      end
    end,requires={'nvim-telescope/telescope.nvim'}},
    'lukaspietzschmann/telescope-tabs',
    'nvim-telescope/telescope-file-browser.nvim',
  },config=function ()
      local telescope=require'telescope'
      telescope.load_extension'fzf'
      telescope.setup{}
    end,cond=lcmd{'Telescope'}},

  ----window
  {'sindrets/winshift.nvim',config=function ()
    require'winshift'.setup{}
    for k,v in pairs({h='left',j='down',k='up',l='right'}) do
      require'utils.keymap'.nno('<C-S-'..k..'>',':WinShift '..v..'\r')
    end end,cond=lkey{n={'<C-S-h>','<C-S-j>','<C-S-k>','<C-S-l>'}}},
  {'wesQ3/vim-windowswap',cond=lkey{n={'\\ww'}}},
  {'t9md/vim-choosewin',config=function ()
    vim.g.choosewin_overlay_enable=1
    require'utils.keymap'.nno('<C-w> ',':ChooseWin\r')
  end,cond=function(load)
      lkey{n={'<C-w><space>'}}(load)
      lcmd{'ChooseWin'}(load)
    end},

  ----treesitter
  {'nvim-treesitter/nvim-treesitter',config=get_config'treesitter'},
  {'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',cond=ll,config=function()
    vim.g.rainbow_delimiters={blacklist={'zig'}}
    vim.cmd'TSEnable rainbow'
  end,requires={'nvim-treesitter/nvim-treesitter'}},
  {'windwp/nvim-ts-autotag',cond=function(load)
    vim.api.nvim_create_autocmd('User',{pattern='autotag',callback=load,once=true})
  end,config=function() vim.cmd"TSEnable autotag" end,ft='html'},
  {'rrethy/nvim-treesitter-endwise',cond=levent{'InsertEnter'},config=function() vim.cmd"TSEnable endwise" end,requires={'nvim-treesitter/nvim-treesitter'}}, --TODO
  {'ziontee113/syntax-tree-surfer',config=get_config'surfer',
    cond=lkey{n={'vx','vn','<A-j>','<A-k>','<A-S-k>','<A-S-j>','gF','gX'},x={'<C-j>','<C-k>','<C-h>','<C-l>','<C-S-h>','<C-S-j>','<C-S-k>','<C-S-l>','<A-k>','<A-j>','gX'}},requires={'nvim-treesitter/nvim-treesitter'}},

  ----other
  {'sindrets/diffview.nvim',cond=lcmd({'Open','FileHistory','Close','FocusFiles','ToggleFiles','Refresh','Log'},'Diffview'),
    config=get_setup('diffview',{use_icons=false})},
  {'neovim/nvim-lspconfig',config=get_config'lsp',requires={
    {'williamboman/mason.nvim',module='mason'},
    {'kosayoda/nvim-lightbulb',module='nvim-lightbulb'},
    {'folke/neodev.nvim',opt=true}},cond=ll},
  {'glepnir/dashboard-nvim',config=get_config'dashboard',cond=function (load)
    lcmd{'Dashboard'}(load)
    vim.api.nvim_create_autocmd({'Vimenter'},{callback=function()
      if vim.fn.argc()==0 and vim.api.nvim_buf_line_count(0)==1 and vim.api.nvim_get_current_line()=='' and vim.api.nvim_buf_get_name(0)=='' then
        vim.cmd('Dashboard')
      end end})end},
  {'rafcamlet/nvim-luapad',cond=lcmd{'Luapad'},config=get_config'luapad'},
  {'m-demare/attempt.nvim',config=get_config'attempt',cond=lkey{n={'\\a'}}},
  {'rcarriga/nvim-notify',cond=function(load)
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify=function (...)
      load()
      vim.notify=require"notify"
      vim.notify(...)
    end end},
  {'echasnovski/mini.nvim',config=get_config'mini'},
  {'nmac427/guess-indent.nvim',config=get_setup'guess-indent'},
  {'raghur/vim-ghost',run=':GhostInstall',cond=lcmd{'GhostStart'},config=get_rplugin()},
  --use{'andweeb/presence.nvim'},

  ----auto complete (nvim-cmp & snippy)
  {'hrsh7th/nvim-cmp',commit='6c84bc7',config=get_config'cmp-nvim',cond=levent{'InsertEnter','CmdlineEnter'}}, --TODO: temp commit; https://github.com/jcdickinson/codeium.nvim/issues/80
    {'hrsh7th/cmp-cmdline',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'dmitmel/cmp-cmdline-history',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    ----{'dcampos/cmp-snippy'},
    ----{'dcampos/nvim-snippy',requires='honza/vim-snippets',config=get_config'snippy'},
    {'f3fora/cmp-spell',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'hrsh7th/cmp-calc',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'hrsh7th/cmp-buffer',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'hrsh7th/cmp-nvim-lsp',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'hrsh7th/cmp-nvim-lsp-signature-help',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'FelipeLema/cmp-async-path',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'lukas-reineke/cmp-rg',requires={'hrsh7th/nvim-cmp'},cond=levent{'InsertEnter','CmdlineEnter'}},
    {'jcdickinson/codeium.nvim',config=get_setup'codeium',requires={'hrsh7th/nvim-cmp','nvim-lua/plenary.nvim'},cond=levent{'InsertEnter','CmdlineEnter'}},

  ----writing
  {'JellyApple102/easyread.nvim',config=get_setup('easyread',{fileTypes={'markdown','text'}}),cond=lft{'markdown','text'}}, --TODO
  {'potamides/pantran.nvim',cond=lcmd{'Pantran'}}, --TODO
  {'jbyuki/venn.nvim',cond=function()
    lcmd{'Fill'}(load)
    lcmd({'D','H','O','DO','HO'},'VBox')(load) end},
  {'dhruvasagar/vim-table-mode',cond=lcmd{'TableModeToggle'}},
    {'dbmrq/vim-ditto',cond=function(load)
    lcmd{'NoDitto','ToggleDitto'}(load)
    lcmd({'Sent','Par','File','On','Off','Update','SentOn','ParOn','FileOn'},'Ditto')(load)
  end},
  {'reedes/vim-wordy',cond=lcmd{'Wordy','NoWordy'}},
  {'ron89/thesaurus_query.vim',cond=lcmd({'QueryReplaceCurrentWord','QueryLookupCurrentWord','QueryReplace',''},'Thesaurus')}, --TODO
  --{'epwalsh/obsidian.nvim',config=get_setup('obsidian'),cond=lft{'markdown'}},

  ----filetype
  {'nvim-neorg/neorg',config=get_setup(
    'neorg',{load={
      ['core.defaults']={},
      ['core.export']={},
      ['core.export.markdown']={},
      ['core.concealer']={},
--['core.presenter']={},
--['core.completion']={},
}}),cond=lft{'norg'}},
{'iamcco/markdown-preview.nvim',run='cd app && npm install',cond=lft{'markdown'}},
{'turbio/bracey.vim',run='npm install --prefix server',cond=lft{'html','css','javascript'}},

---end
}
-- vim:fen:
