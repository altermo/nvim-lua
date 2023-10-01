----init
local function fmap(num,cmd,name)
  local tbl={}
  for i=1,num do
    tbl[tostring(i)]={cmd:gsub('%%s',i),(name:gsub('%%s',tostring(i)))}
  end
  return tbl
end
local function cmap(inp,cmd,name,add)
  local tbl={}
  for k,v in pairs(inp) do
    tbl[k]=vim.tbl_extend('error',{cmd:format(v),name:format(v)},add or {})
  end
  return tbl
end
local function format(tbl)
  for k,v in pairs(tbl) do
    if k=='_' then
      for k2,v2 in pairs(tbl._) do
        tbl[k2]=v2
      end
      tbl._=nil
    elseif type(v)=='table' then
      format(v)
    end
  end
  return tbl
end
local spell={s='es',e='en',v='sv',n='nb'}
local mouse_center={}
local saved_pos={}
require'which-key'.setup{plugins={
  marks=false,
  registers=false,
  spelling={enabled=false},
  presets={
    operators=false,
    motions=false,
    text_objects=false,
    windows=false,
    nav=false,
    z=false,
    g=false,
  }}}
require'which-key'.register{[' ']=format{

  ----main
  b={require'small.bufend'.run,'bufend'},
  L={':Luapad\r','luapad'},
  C={require'small.chat'.run,'chat'},
  ['.']={'@:','run-prev-cmd'},
  r={require'small.ranger'.run,'ranger'},
  ["'"]={':Shell\r','shell'},
  t={require'small.unimpaired'.set_opt,'toggle opt'},
  ------fold
  z={'zM100zo','close-all-folds-but-cursor'},
  Z={':e\r','reload-folds'},
  ------window/buffer
  q={':q\r','quit'},
  Q={':q!\r','QUIT!'},
  x={':qall\r','quitall'},
  v={require'small.splitbuf'.vsplit,'vsplitbuf'},
  e={require'small.splitbuf'.split,'hsplitbuf'},
  n={require'small.splitbuf'.open,'splitbuf'},
  d={':lua require"mini.bufremove".delete()\r','buffer-close'},
  o={':on\r','only-window'},
  ------move
  ['>']={function()
    if not saved_pos[1] then
      vim.notify"stack empty"
      return
    end
    vim.api.nvim_set_current_buf(saved_pos[#saved_pos].buf)
    vim.api.nvim_win_set_cursor(0,saved_pos[#saved_pos].cur)
    table.remove(saved_pos,#saved_pos)
  end,'pop-pos'},
  ['<']={function()
    saved_pos[#saved_pos+1]={
      cur=vim.api.nvim_win_get_cursor(0),
      buf=vim.api.nvim_get_current_buf(),
    }
  end,'push-pos'},

  ---uncategorized TODO
  ['?']={name='uncategorized',
    j={name='+jump',
      t={'<cmd>lua require"flash".treesitter()\r','tree'},
      f={':Telescope current_buffer_fuzzy_find\r','find-whole-file'},
      h={'<cmd>lua require"flash".jump()\r','1 char'},
      l={'<cmd>lua require("flash").jump({search={mode="search",max_length=0},label={after={0,0}},pattern="^"})\r','line'},
      d={require'small.dff'.file_expl,'dff'},
    },
    T={':InspectTree\r','TSPlayground'},
    u={':MundoToggle\r','undotree'},
    a={':TableModeToggle\r','table-mode'},
    n={':lua require"notify".dismiss({pending=true,silent=true})\r','dismiss notify'},
    C={function()
      local buf=vim.fn.bufnr() --[[@as number]]
      if mouse_center[buf] then
        vim.api.nvim_del_autocmd(mouse_center[buf])
        mouse_center[buf]=nil
      else
        mouse_center[buf]=vim.api.nvim_create_autocmd('CursorMoved,CursorMovedI',{command='norm! zz',buffer=buf})
        vim.cmd.norm {'zz',bang=true}
      end
    end,'centermouse'},
    e={':silent !emacsclient %&\r','send-emacs'},
    w={':call execute("terminal curl \'wttr.in/?nQF\' -s")|startinsert\r','weather'},
    i={':edit .\r','edir'},
    m={':MarkdownPreview\r','markdown-preview'},
    c={name='+otherc',
      D={function ()
        local tomorrow=os.time()+24*60*60
        return '/'..os.date('@%Y-%m-%d')..'\rlc5e'..os.date('%Y-%m-%d',tomorrow)..''
      end,'increment-date',expr=true},
      ['<C-d>']={function ()
        local yesterday=os.time()-24*60*60
        return '/'..os.date('@%Y-%m-%d',yesterday)..'\rlc5e'..os.date('%Y-%m-%d')..''
      end,'increment-date',expr=true},
      l={':edit /tmp/nlog\r','open-nlog'},
      T={':lua require "mini.trailspace".trim()\r','trim spaces'},
      ------treesitter
      t={name='+treesitter',
        e={':hi link TSError NvimInternalError\r','highlight error'},
        f={':set foldexpr=v:lua.vim.treesitter.foldexpr()\r','set-foldexpr'},
      },
      ------foldmethod
      f={name='+foldmethod',
        _=cmap({m='manual',i='indent',e='expr',M='marker',S='syntax',d='diff'},':set foldmethod=%s\r','%s'),
        t={':set foldmethod=expr\r:set foldexpr=v:lua.vim.treesitter.foldexpr()\r','treesitter'},
        d={':set foldmethod=expr\r:set foldexpr=v:lua.Fold(v:lnum)\r','default'},
      },
      ------foldlevel
      F={name='+foldlevel',
        _=fmap(9,':set foldlevel=%s\r','%s')
      },
      ------indent
      i={name='+indent',
        _=fmap(9,':set sw=%s ts=%s sts=%s\r','set indent=%s'),
      },
      ------git
      g={':DiffviewOpen\r','git-diff'},
    },
  },

  ---tabs
  ['<tab>']={name='+tab',
    n={':tabnext\r','next'},
    p={':tabprev\r','prev'},
    d={':tabclose\r','delete'},
    c={':tabclose\r','close'},
    q={':tabclose\r','quit'},
    ['<tab>']={':tabnext\r','next'},
    ['<']={':-tabmove\r','move-prev'},
    ['>']={':+tabmove\r','move-next'},
    [' ']={':exe "tabe ".expand("%:p")\r<C-o>','new'},
    _=fmap(9,':tabnext %s\r','tab-%s'),
    ['0']={':tablast\r','tab-last'},
    m={name='+move-buffer',
      _=fmap(9,':lua require"utils.lib".tabbufmove(%s)\r','tab-%s'),
      ['0']={function() require'utils.lib'.tabbufmove'$' end,'last'},
      ['<']={function() require'utils.lib'.tabbufmove'-' end,'prev'},
      ['>']={function() require'utils.lib'.tabbufmove'+' end,'next'},
    },
  },

  ---files
  f={name='+files',
    W={function ()
      local tmp=vim.fn.tempname()
      vim.fn.writefile(vim.fn.getline(1,vim.fn.line('$')),tmp)
      vim.o.modified=false
      vim.cmd.vnew()
      local buf=vim.fn.bufnr()
      vim.fn.termopen('cat '..tmp..'|sudo tee '..vim.fn.expand('#:p'),{
        on_exit=function (_,_,_)
          vim.cmd.bdelete({buf,bang=true})
        end
      })
      vim.cmd.startinsert()
    end,'sudosave'},
    r={':Rename\r','rename',silent=false},
    d={':Duplicate\r','duplicate'},
    c={':!echo "%:p"|xsel -ib\r','copy-path',silent=false},
    C={':!echo "%:r"|tr "/" "."|xsel -ib\r','copy-lua-path',silent=false},
    f={':Telescope find_files\r','find'},
    t={name='+set-type',
      o={':setf ','other',silent=false},
      _=cmap({p='python',t='txt',v='vim',s='fish',f='fennel',r='rust',l='lua',m='markdown',c='c',h='html',n="norg"},':set filetype=%s\r','%s')
    },
  },

  ----search
  s={name='+search',
    a={':Telescope\r','telescope'},
    c={':Telescope colorscheme enable_preview=true\r','colorscheme'},
    F={require'small.foldselect'.run,'fold'},
    P={require'small.plugin_search'.run,'plugins-online'},
    _=cmap({f='find_files',o='oldfiles',s='live_grep',h='help_tags'},':Telescope %s theme=ivy\r','%s'),
    y={':Telescope yank_history yank_history\r','yank'},
    g={name='+git',
      _=cmap({s='git_status',c='git_commits',b='git_branches'},':Telescope %s theme=ivy\r','%s'),
    },
    r={name='+replace',
      p={require'small.lbpr'.run,'lbpr'},
      r={':Spectre\r','spectre'},
      w={':%s/\\<<C-r>=expand("<cword>")\r\\>//<Left>','word',silent=false},
    }
  },

  ----packer
  p={name='+packer',
    _=cmap({p='status',i='install',c='clean',u='update'},':Pckr %s\r','%s'),
  },

  ----text
  y={name='+text',
    S={function ()
      local t=require'small.trans'
      t.conf.from,t.conf.to=t.conf.to,t.conf.from
      vim.notify(('%s to %s'):format(t.conf.from,t.conf.to))
    end,'translate-swap'},
    T={function ()
      local t=require'small.trans'
      vim.notify(('%s to %s'):format(t.conf.from,t.conf.to))
    end,'translate-show'},
    f={name='+translate-from',
      f={':lua require"small.trans".conf.from=""<Left>','other',silent=false},
      _=cmap(spell,':lua require"small.conf.trans".from="%s"\r','lang=%s',{silent=false})
    },
    t={name='+translate-to',
      t={':lua require"small.trans".conf.to=""<Left>','other',silent=false},
      _=cmap(spell,':lua require"small.trans".conf.to="%s"\r','lang=%s',{silent=false})
    },
    s={name='+spell',
      _=cmap(spell,':set spelllang=%s\r','lang=%s',{silent=false})
    },
    g={name='+grammar',
      w={':Wordy weak\r','wordy on'},
      W={':NoWordy\r','wordy off'},
      d={':ToggleDitto\r','ditto'},
    },
  },

  ----theme
  T={name='+theme',
    ['\r']={':set hls!\r','highlight'},
    h={':ColorizerToggle\r','toggle-color-name-highlight'},
    z={require'small.zen'.run,'zen'},
    ['+']={function()
      vim.o.guifont=vim.fn.substitute(vim.o.guifont,[[\vh(\d+)]],'\\="h".(submatch(1)+1)','')
    end,'zoom in'},
    ['-']={function()
      vim.o.guifont=vim.fn.substitute(vim.o.guifont,[[\vh(\d+)]],'\\="h".(submatch(1)-1)','')
    end,'zoom out'},
    ['0']={function()
      vim.o.guifont=vim.fn.substitute(vim.o.guifont,[[\vh(\d+)]],'h11','')
    end,'zoom reset'},
    C={function ()
      vim.cmd.hi('Cursor blend=100')
      vim.o.guicursor='a:Cursor/lCursor,a:ver1'
    end,'hide-cursor'},
    c={':set guicursor&\r','reset-cursor'},
    f={':set guifont=*\r','select-font'},
    m={':ToggleMatchAll\r','toggle matchall'},
  },

  ----lsp
  l={name='+lsp',
    h={':lua vim.lsp.buf.hover()\r','hover'},
    f={':lua vim.lsp.buf.format()\r','format'},
    c={':lua vim.lsp.buf.code_action()\r','code-action'},
    I={':lua vim.lsp.inlay_hint(0)\r','toggle-inlay-hint'},
    i={':LspInfo\r','info'},
    s={':LspStop\r','stop'},
    S={':LspStart\r','start-lsp'},
    m={':Mason\r','mason'},
    r={':Telescope lsp_references\r','search-references'},
    R={':IncRename <C-r>=expand("<cword>")\r','replace',silent=false},
    w={name='+workspace',
      a={vim.lsp.buf.add_workspace_folder,'add'},
      d={vim.lsp.buf.remove_workspace_folder,'delete'},
      l={':=vim.lsp.buf.list_workspace_folders()\r','list',silent=false},
    },
  },

  ---window
  w={name='+window',
    o={':only\r','only-window'},
    v={':vsplit\r','vsplit'},
    e={':split\r','split'},
    c={':close\r','close'},
    d={':close\r','delete'},
    q={':close\r','quit'},
    w={':wincmd w\r','next'},
    ['<tab>']={':wincmd w\r','next'},
    _=(function ()
      local ret=fmap(9,':%swincmd w\r','window %s')
      for k,v in pairs{
        h={'<','decrease width','left'},
        j={'+','increase height','down'},
        k={'-','decrease height','up'},
        l={'>','increase width','right'},
      } do
        ret[k]={':wincmd '..k..'\r',v[3]}
        ret['<S-'..k..'>']={':5wincmd '..v[1]..'\r',v[2]}
        ret['<C-S-'..k..'>']={':wincmd '..v[1]..'\r','small '..v[2]}
        ret['<C-'..k..'>']={':WinShift '..v[3]..'\r','move '..v[3]}
      end
      return ret
    end)(),
    s={function()
      local win=require('window-picker').pick_window()
      if not win then return end
      local curbuf=vim.api.nvim_win_get_buf(0)
      local otherbuf=vim.api.nvim_win_get_buf(win)
      vim.api.nvim_win_set_buf(0,otherbuf)
      vim.api.nvim_win_set_buf(win,curbuf)
    end,'swap'},
    [' ']={function()
      local win=require('window-picker').pick_window()
      if not win then return end
      vim.api.nvim_set_current_win(win)
    end,'hop'},
  },

  ---project
  P={name='+project',
    p={':Telescope project project\r','search'},
    r={':source /tmp/session.vim\r','reload-last-session',silent=false},
    P={':exe "edit" v:oldfiles[0]\r','reload-last-file'},
    W={'wshada','write shada'},
    R={'rshada','read shada'},
  },
}}
