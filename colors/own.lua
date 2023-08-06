vim.cmd'highlight clear'
local bcolor={{
    u='#ff0000',
    mainbg='#191919',
    mainfg='#888888',
    secondbg='#242424',
    secondfg='#555555',

    selectbg='#242424',
    select2bg='#a03000',
    select3bg='#c06070',
    selectfg='#9ff895',
    visual='#600000',

    yellow='#ffa82b',
    purple='#ca6ecf',
    pink='#ffc4ff',
    black='#000000',
    green='#9ff895',
    invgreen='#192919',
    invred='#391919',
    invyellow='#393919',

    warning='#f0fa43',
    error='#fa1111',
    important='#2ff381',
    nimportant='#444444',

    func='#00CED1',
    var='#4169E1',
    block='#00a5c5',
    oper='#888808',
    delimiter='#777707',
},{
    u='#ff0000',
    mainbg='#0a3a2a',
    mainfg='#d0d0d0',
    secondbg='#324747',
    secondfg='#bbbbbb',

    selectbg='#242424',
    select2bg='#a03000',
    select3bg='#c06070',
    selectfg='#9ff895',
    visual='#000a2a',

    yellow='#9f8340',
    purple='#ca6ecf',
    pink='#ffc4ff',
    black='#000000',
    green='#9ff895',
    invgreen='#192919',
    invred='#391919',
    invyellow='#393919',

    warning='#f0fa43',
    error='#fa1111',
    important='#2ff381',
    nimportant='#788a8a',

    func='#00CED1',
    var='#4169E1',
    block='#00a5c5',
    oper='#888808',
    delimiter='#777707',
}}
local function set_hl(name,val)
    vim.api.nvim_set_hl(0,name,val)
end
local p=bcolor[vim.fn.rand()%#bcolor+1]
---NORMAL
set_hl('Normal',{bg=p.mainbg,fg=p.mainfg})
set_hl('NormalFloat',{bg=p.secondbg,fg=p.mainfg})
set_hl('EndOfBuffer',{bg='bg',fg='bg'})
---VISUAL
set_hl('Visual',{bg=p.visual})
---CURSOR/COLUM
local linebg=p.secondbg
set_hl('LineNr',{bg=linebg,fg=p.secondfg})
set_hl('CursorLineNr',{bg=linebg,fg=p.yellow})
set_hl('Cursor',{bg=p.mainfg})
set_hl('CursorLine',{bg=p.secondbg})
set_hl('CursorColumn',{bg=linebg})
---FOLD/COLUMNS
set_hl('Folded',{bg=linebg,fg="fg"})
set_hl('FoldColumn',{bg=linebg,fg=p.purple})
set_hl('SignColumn',{bg=linebg})
set_hl('ColorColumn',{bg=p.secondbg})
---TERM
set_hl('TermCursor',{link='Cursor'})
set_hl('TermCursorNC',{link='TermCursor'})
---MENU|SPLIT
set_hl('WildMenu',{bg=p.u})
set_hl('WinSeparator',{bg='bg'})
---TAB
set_hl('TabLine',{bg=p.secondbg,fg=p.secondfg})
set_hl('TabLineSel',{bg=p.selectbg,fg=p.selectfg,bold=true})
set_hl('TabLineFill',{bg=p.secondbg})
---STATUS
set_hl('StatusLine',{bg=p.secondbg,fg=p.mainfg})
set_hl('StatusLineNC',{bg=p.secondbg,fg=p.secondfg})
---PMENU
set_hl('Pmenu',{bg=p.secondbg,fg=p.mainfg})
set_hl('PmenuSel',{bg=p.selectbg,fg=p.selectfg,bold=true})
set_hl('PmenuSbar',{bg=p.secondbg,fg=p.mainfg})
set_hl('PmenuThumb',{bg=p.selectbg})
---SEARCH
set_hl('Search',{bg=p.select2bg,bold=true})
set_hl('Substitute',{link='Search'})
set_hl('IncSearch',{link='Search'})
set_hl('CurSearch',{bg=p.select3bg})
---OTHER
set_hl('Conceal',{fg=p.u})
set_hl('SpecialKey',{fg=p.secondfg,bold=true})
set_hl('NonText',{fg=p.secondfg})
set_hl('MatchParen',{bg=p.select2bg})
set_hl('Whitespace',{fg=p.secondfg})
set_hl('Directory',{fg=p.pink})
set_hl('Title',{fg=p.yellow,bold=true})
set_hl('Todo',{fg=p.important})
set_hl('Bold',{bold=true})
set_hl('Italic',{italic=true})
set_hl('Error',{bg=p.error})
---MSG_AREA
set_hl('MoreMsg',{fg=p.selectfg,bold=true})
set_hl('Question',{fg=p.selectfg,bold=true})
---MSG
set_hl('WarningMsg',{fg=p.warning})
set_hl('ErrorMsg',{fg=p.error})
set_hl('ModeMsg',{fg=p.important})
---CHECKHEALT
set_hl('healthError',{link='ErrorMsg'})
set_hl('healthSuccess',{link='Msg'})
set_hl('healthWarning',{link='WarningMsg'})
---MAIN
set_hl('Tag',{fg=p.important})
set_hl('Link',{bg=p.u})
set_hl('URL',{bg=p.u})
set_hl('Underlined',{fg=p.important})
set_hl('Comment',{fg=p.nimportant})
---CAT1
set_hl('Macro',{fg=p.purple})
set_hl('Define',{fg=p.pink})
set_hl('Include',{fg=p.pink})
set_hl('PreProc',{fg=p.important})
set_hl('PreCondit',{bg=p.u})
---CAT2
set_hl('Label',{fg=p.important})
set_hl('Repeat',{fg=p.block})
set_hl('Keyword',{fg=p.yellow})
set_hl('Operator',{fg=p.oper})
set_hl('Delimiter',{fg=p.delimiter})
set_hl('Statement',{fg=p.yellow})
set_hl('Exception',{fg=p.block})
set_hl('Conditional',{fg=p.block})
---CAT3
set_hl('Variable',{fg=p.var})
set_hl('VariableBuiltin',{bg=p.u})
set_hl('Constant',{fg=p.important})
---CAT4
set_hl('Number',{fg=p.purple})
set_hl('Float',{fg=p.purple})
set_hl('Boolean',{fg=p.pink})
set_hl('Enum',{bg=p.u})
---CAT5
set_hl('SpecialChar',{link='SpecialKey'})
set_hl('String',{fg=p.green})
set_hl('Character',{link='String'})
set_hl('StringDelimiter',{bg=p.u})
---CAT6
set_hl('Special',{fg=p.pink})
set_hl('Field',{fg=p.purple})
set_hl('Argument',{bg=p.u})
set_hl('Attribute',{bg=p.u})
set_hl('Identifier',{fg=p.purple})
set_hl('Property',{bg=p.u})
set_hl('Function',{fg=p.func})
set_hl('FunctionBuiltin',{bg=p.u})
set_hl('KeywordFunction',{bg=p.u})
set_hl('Method',{bg=p.u})
---CAT7
set_hl('Type',{fg=p.green})
set_hl('Typedef',{fg=p.block})
set_hl('TypeBuiltin',{bg=p.u})
set_hl('Class',{bg=p.u})
set_hl('StorageClass',{fg=p.purple})
set_hl('Structure',{fg=p.pink})
---CAT8
set_hl('Regexp',{bg=p.u})
set_hl('RegexpSpecial',{bg=p.u})
set_hl('RegexpDelimiter',{bg=p.u})
set_hl('RegexpKey',{bg=p.u})
---CAT9
set_hl('CommentURL',{bg=p.u})
set_hl('CommentLabel',{bg=p.u})
set_hl('CommentSection',{bg=p.u})
set_hl('Noise',{bg=p.u})
---DIFF
set_hl('DiffAdd',{bg=p.invgreen})
set_hl('DiffChange',{bg='bg'})
set_hl('DiffDelete',{bg=p.invred})
set_hl('DiffText',{bg=p.invyellow})
---LSP
set_hl('DiagnosticFloatingError',{link='ErrorMsg'})
set_hl('DiagnosticFloatingWarn',{link='WarningMsg'})
set_hl('DiagnosticFloatingInfo',{link='MoreMsg'})
set_hl('DiagnosticFloatingHint',{link='Msg'})
set_hl('DiagnosticDefaultError',{link='ErrorMsg'})
set_hl('DiagnosticDefaultWarn',{link='WarningMsg'})
set_hl('DiagnosticDefaultInfo',{link='MoreMsg'})
set_hl('DiagnosticDefaultHint',{link='Msg'})
set_hl('DiagnosticVirtualTextError',{link='ErrorMsg'})
set_hl('DiagnosticVirtualTextWarn',{link='WarningMsg'})
set_hl('DiagnosticVirtualTextInfo',{link='MoreMsg'})
set_hl('DiagnosticVirtualTextHint',{link='Msg'})
set_hl('DiagnosticSignError',{link='ErrorMsg'})
set_hl('DiagnosticSignWarning',{link='WarningMsg'})
set_hl('DiagnosticSignInformation',{link='MoreMsg'})
set_hl('DiagnosticSignHint',{link='Msg'})
set_hl('LspHighlight',{underline=true,sp=p.pink})
set_hl('LspReferenceText',{link='LspHighlight'})
set_hl('LspReferenceRead',{link='LspHighlight'})
set_hl('LspReferenceWrite',{link='LspHighlight'})
---Spell
set_hl('SpellBad',{undercurl=true,sp='#b73424',bold=true})
set_hl('SpellCap',{undercurl=true,sp='#0030c7',bold=true})
set_hl('SpellLocal',{undercurl=true,sp='#7050c7',bold=true})
set_hl('SpellRare',{undercurl=true,sp='#50a007',bold=true})
---TS
set_hl('@field',{link='Field'})
set_hl('@variable',{link='Variable'})
set_hl('@text.strong',{link='Bold'})
set_hl('@text.emphasis',{link='Italic'})
---LSP
set_hl('@lsp.type.variable',{link='Variable'})
---EXT
set_hl('DashboardHeader',{link='Title'})
set_hl('DashboardDesc',{link='Include'})
---TERM
vim.g.terminal_color_0='#000000'
vim.g.terminal_color_1='#FF0000'
vim.g.terminal_color_2='#00FF00'
vim.g.terminal_color_3='#FFFF00'
vim.g.terminal_color_4='#0000FF'
vim.g.terminal_color_5='#FF00FF'
vim.g.terminal_color_6='#00FFFF'
vim.g.terminal_color_7='#EEEEEE'
vim.g.terminal_color_8='#888888'
vim.g.terminal_color_9='#FF8888'
vim.g.terminal_color_10='#88FF88'
vim.g.terminal_color_11='#FFFF88'
vim.g.terminal_color_12='#8888FF'
vim.g.terminal_color_13='#FF88FF'
vim.g.terminal_color_14='#88FFFF'
vim.g.terminal_color_15='#FFFFFF'
vim.g.colors_name='own'
