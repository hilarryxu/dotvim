" Vim Color File
"
" Name: xoria256mod
" Version: 0.2
" Maintainer: deuiore <de@uio.re>
" Website: https://github.com/deuiore/vim-xoria256mod
"
" Based_on: xoria256 v1.6
" MOD:
"   - Tabs to spaces and spacing consistency;
"   - added ExtraWS, ColorColumn, SignColumn;
"   - added Boolean, Character, Conditional, Debug, Define, Delimiter,
"     Directory, Exception, Float, Function, Include, Keyword,, Label, Macro,
"     ModeMsg, MoreMsg, Operator, PreCondit, Question, Repeat, SignColumn,
"     SpecialChar, SpecialComment, StorageClass, String, Structure,
"     TabLineSel, Tag, Typedef, WarningMsg, diffChanged, diffFile, diffLine,
"     diffOldLine of bubblegum's inspiration;
"   - added 'Markdown' section;
"   - removed error during initialization;
"   - removed commented alternatives.

" Initialization {{{
set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "xoria256mod"
"}}}

" Colours {{{1
"" General {{{2
hi ColorColumn                                  ctermbg=233 guibg=#121212
hi Cursor                                       ctermbg=214 guibg=#ffaf00
hi CursorColumn                                 ctermbg=238 guibg=#444444
hi CursorLine                                   ctermbg=237 guibg=#3a3a3a cterm=none      gui=none
hi Debug              ctermfg=174 guifg=#d78787
hi Directory          ctermfg=103 guifg=#8787af
hi Error              ctermfg=15  guifg=#ffffff ctermbg=1   guibg=#800000
hi ErrorMsg           ctermfg=15  guifg=#ffffff ctermbg=1   guibg=#800000
hi FoldColumn         ctermfg=247 guifg=#9e9e9e ctermbg=233 guibg=#121212
hi Folded             ctermfg=255 guifg=#eeeeee ctermbg=60  guibg=#5f5f87
hi IncSearch          ctermfg=0   guifg=#000000 ctermbg=223 guibg=#ffdfaf cterm=none      gui=none
hi LineNr             ctermfg=247 guifg=#9e9e9e ctermbg=233 guibg=#121212
hi MatchParen         ctermfg=188 guifg=#dfdfdf ctermbg=68  guibg=#5f87df cterm=bold      gui=bold
hi ModeMsg            ctermfg=222 guifg=#ffd787
hi MoreMsg            ctermfg=72  guifg=#5faf87
hi NonText            ctermfg=247 guifg=#9e9e9e ctermbg=233 guibg=#121212 cterm=bold      gui=bold
hi Normal             ctermfg=252 guifg=#d0d0d0 ctermbg=234 guibg=#1c1c1c cterm=none      gui=none
hi Pmenu              ctermfg=0   guifg=#000000 ctermbg=250 guibg=#bcbcbc
hi PmenuSbar                                    ctermbg=252 guibg=#d0d0d0
hi PmenuSel           ctermfg=255 guifg=#eeeeee ctermbg=243 guibg=#767676
hi PmenuThumb         ctermfg=243 guifg=#767676
hi Question           ctermfg=38  guifg=#00afd7
hi Search             ctermfg=0   guifg=#000000 ctermbg=149 guibg=#afdf5f
hi SignColumn         ctermfg=247 guifg=#9e9e9e ctermbg=233 guibg=#121212
hi SignColumn         ctermfg=248 guifg=#a8a8a8
hi SpecialKey         ctermfg=77  guifg=#5fdf5f
hi SpellBad           ctermfg=160 guifg=fg      ctermbg=bg                cterm=underline               guisp=#df0000
hi SpellCap           ctermfg=189 guifg=#dfdfff ctermbg=bg  guibg=bg      cterm=underline gui=underline
hi SpellLocal         ctermfg=98  guifg=#875fdf ctermbg=bg  guibg=bg      cterm=underline gui=underline
hi SpellRare          ctermfg=168 guifg=#df5f87 ctermbg=bg  guibg=bg      cterm=underline gui=underline
hi StatusLine         ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold      gui=bold
hi StatusLineNC       ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none      gui=none
hi TabLine            ctermfg=fg  guifg=fg      ctermbg=242 guibg=#666666 cterm=none      gui=none
hi TabLineFill        ctermfg=fg  guifg=fg      ctermbg=237 guibg=#3a3a3a cterm=none      gui=none
hi TabLineSel         ctermfg=253 guifg=#dadada ctermbg=238 guibg=#444444 cterm=none      gui=none
hi Title              ctermfg=225 guifg=#ffdfff
hi Todo               ctermfg=0   guifg=#000000 ctermbg=184 guibg=#dfdf00
hi Underlined         ctermfg=39  guifg=#00afff                           cterm=underline gui=underline
hi VertSplit          ctermfg=237 guifg=#3a3a3a ctermbg=237 guibg=#3a3a3a cterm=none      gui=none
hi Visual             ctermfg=255 guifg=#eeeeee ctermbg=96  guibg=#875f87
hi VisualNOS          ctermfg=255 guifg=#eeeeee ctermbg=60  guibg=#5f5f87
hi WarningMsg         ctermfg=140 guifg=#af87d7
hi WildMenu           ctermfg=0   guifg=#000000 ctermbg=150 guibg=#afdf87 cterm=bold      gui=bold
"" Syntax highlighting {{{2
hi Boolean            ctermfg=187 guifg=#d7d7af
hi Character          ctermfg=187 guifg=#d7d7af
hi Comment            ctermfg=244 guifg=#808080
hi Conditional        ctermfg=110 guifg=#87afd7
hi Constant           ctermfg=229 guifg=#ffffaf
hi Define             ctermfg=150 guifg=#afd787
hi Delimiter          ctermfg=174 guifg=#d78787
hi Exception          ctermfg=110 guifg=#87afd7
hi Float              ctermfg=179 guifg=#d7af5f
hi Function           ctermfg=182 guifg=#d7afd7
hi Identifier         ctermfg=182 guifg=#dfafdf                           cterm=none
hi Ignore             ctermfg=238 guifg=#444444
hi Include            ctermfg=150 guifg=#afd787
hi Keyword            ctermfg=110 guifg=#87afd7
hi Label              ctermfg=110 guifg=#87afd7
hi Macro              ctermfg=150 guifg=#afd787
hi Number             ctermfg=180 guifg=#dfaf87
hi Operator           ctermfg=110 guifg=#87afd7
hi PreCondit          ctermfg=150 guifg=#afd787
hi PreProc            ctermfg=150 guifg=#afdf87
hi Repeat             ctermfg=110 guifg=#87afd7
hi Special            ctermfg=174 guifg=#df8787
hi SpecialChar        ctermfg=174 guifg=#d78787
hi SpecialComment     ctermfg=174 guifg=#d78787
hi Statement          ctermfg=110 guifg=#87afdf                           cterm=none      gui=none
hi StorageClass       ctermfg=146 guifg=#afafd7
hi String             ctermfg=187 guifg=#d7d7af
hi Structure          ctermfg=146 guifg=#afafd7
hi Tag                ctermfg=174 guifg=#d78787
hi Type               ctermfg=146 guifg=#afafdf                           cterm=none      gui=none
hi Typedef            ctermfg=146 guifg=#afafd7

"" Special Syntax {{{2

""" .diff {{{3
hi diffFile           ctermfg=244 guifg=#808080
hi diffLine           ctermfg=244 guifg=#808080
hi diffAdded          ctermfg=150 guifg=#afdf87
hi diffRemoved        ctermfg=174 guifg=#df8787
hi diffChanged        ctermfg=179 guifg=#d7af5f

""" vimdiff {{{3
hi diffAdd            ctermfg=bg  guifg=bg      ctermbg=151 guibg=#afdfaf
hi diffDelete         ctermfg=bg  guifg=bg      ctermbg=246 guibg=#949494 cterm=none      gui=none
hi diffChange         ctermfg=bg  guifg=bg      ctermbg=181 guibg=#dfafaf
hi diffOldLine        ctermfg=104 guifg=#8787d7
hi diffText           ctermfg=bg  guifg=bg      ctermbg=174 guibg=#df8787 cterm=none      gui=none

""" HTML {{{3
hi htmlTag            ctermfg=244
hi htmlEndTag         ctermfg=244
hi htmlArg            ctermfg=182 guifg=#dfafdf
hi htmlValue          ctermfg=187 guifg=#dfdfaf
hi htmlTitle          ctermfg=254               ctermbg=95
hi htmlTagName        ctermfg=146
hi htmlString         ctermfg=187

""" django {{{3
hi djangoVarBlock     ctermfg=180 guifg=#dfaf87
hi djangoTagBlock     ctermfg=150 guifg=#afdf87
hi djangoStatement    ctermfg=146 guifg=#afafdf
hi djangoFilter       ctermfg=174 guifg=#df8787

""" python {{{3
hi pythonExceptions   ctermfg=174

""" MardDown {{{3
hi mkdCode            ctermfg=244 guifg=#808080
hi mkdURL             ctermfg=111 guifg=#87AFFF
hi mkdLink            ctermfg=181 guifg=#D7AFAF

""" Plugins {{{2

""" NERDTree {{{3
hi Directory          ctermfg=110 guifg=#87afdf
hi treeCWD            ctermfg=180 guifg=#dfaf87
hi treeClosable       ctermfg=174 guifg=#df8787
hi treeOpenable       ctermfg=150 guifg=#afdf87
hi treePart           ctermfg=244 guifg=#808080
hi treeDirSlash       ctermfg=244 guifg=#808080
hi treeLink           ctermfg=182 guifg=#dfafdf

""" vim-hlextraws {{{3
hi ExtraWS                                      ctermbg=1   guibg=#800000

""" Neomake {{{3
hi NeomakeErrorSign   ctermfg=174 guifg=#d78787 ctermbg=233 guibg=#121212 cterm=bold      gui=bold
hi NeomakeWarningSign ctermfg=179 guifg=#d7af5f ctermbg=233 guibg=#121212 cterm=bold      gui=bold
hi NeomakeMessageSign ctermfg=110 guifg=#87afd7 ctermbg=233 guibg=#121212 cterm=bold      gui=bold
hi NeomakeInfoSign    ctermfg=15  guifg=#ffffff ctermbg=233 guibg=#121212 cterm=bold      gui=bold

""" fzf {{{3
hi fzf1               ctermfg=174 guifg=#df8787 ctermbg=233 guibg=#121212
hi fzf2               ctermfg=150 guifg=#afd787 ctermbg=233 guibg=#121212
hi fzf3               ctermfg=251 guifg=#c6c6c6 ctermbg=233 guibg=#121212

""" zeef {{{3
hi ZeefMatch          ctermfg=174 guifg=#df8787 ctermbg=233 guibg=#121212
