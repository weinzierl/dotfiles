" L. Weinzierl, 2013
" http://weinzierlweb.com
"
" This .vimrc is written from scratch and 
" contains basically the intersection of the various 
" .vimrc files I had over the years.
" I tried to include only things I really used over a longer
" period of time.
"
" I try to use the long form (set tabstop=9 instead of set ts=8) 
" consistently.
"

" Most basic settings
set nocompatible  "must be at the beginning of the file
set nomodeline    "interpretation of modelines is a security risk
set shortmess+=I  "no intro message when starting Vim
set guioptions+=b "I like to see the bottom scroll bar always

set ruler     "show line and column number
set showcmd   "show command in bottom right corner (before ruler)
syntax on     "use syntax highlighting
set showmatch "highlight matching brackets

set hidden  "allow switching of buffers which have unsaved changes
set mouse=a "use mouse in xterm to scroll
set scrolloff=5 "5 lines before and after the current line for scrolling

set nobackup   "don't write backup files
set autowriteall "save changes automatically when quitting


set confirm "Use dialog for confirmation
set completeopt=menu,longest,preview "insert mode completion options

set nowrap     "don't wrap long lines per default


"Load pathogen
execute pathogen#infect()

"Backspace
fixdel
inoremap <C-?> <bs>
set backspace=indent,eol,start "modern conventional backspace 
                               "behaviour this was backspace=2 
                               "in older versions it is often set 
                               "by the distro but not always
                               
filetype plugin indent on "automatically load plugins and indentation 
                          "rules this is often set by the distro but 
                          "not always


"Use jj instead of Esc and produce an error when Esc is pressed
inoremap jj <Esc>
inoremap <Esc> Use jj for Esc!

"Undo and History
if v:version >= 730
  set undofile      "enable persistent undo
  set undodir=/tmp  "save undo files in /tmp
endif  
set history=1000 "keep 1000 lines of command line history (default 20)

"Search
set ignorecase  "ignore case
set smartcase   "but don't ignore when search string contains uppercase
set hlsearch    "highlight matches
set incsearch   "do incremental search

"Disable all bells
set noerrorbells  "disable error bell
set visualbell    "set other bells to visual
set t_vb=   "clear the command that does the visual bell
"in gvim setting t_vb works only when the GUI is loaded
autocmd GUIEnter * set visualbell t_vb=

"Tab handling
"Tab handling is confusing, good explanations can be found at
"http://vim.wikia.com/wiki/Indenting_source_code and
"http://vim.wikia.com/wiki/VimTip1626
set expandtab     "tabs will be converted to spaces
                          "For real hard tab use C-V <TAB>.
set tabstop=8      "number of spaces of a tab character
set softtabstop=2  "number of spaces for <TAB> and <BS> 
set smarttab       "use shiftwidth for indenting,
                   "instead of ts/sts depending on et
set shiftwidth=2   "number of space to (auto)indent

set autoindent    "copy indent from current line when starting new line
      "usually the file type plugin will enable smarter indent
      "if this doesn't work set smartindent or cindnet
      "autoindent doesn't interfere with smartindent/cindent

"Wrapping and long lines
set textwidth=0    "do not set line length
set columns=80     "make window 80 columns wide
if v:version >= 730 
  set colorcolumn=+1,+2,+3,+4,+5,+6,+7,+8 "highlight 8 columns after 
endif                                     "textwidth

"Load color scheme
colorscheme solarized

"Folding
function! FoldHierarchicalNumbering(linenum)
  if getline(a:linenum)=~'^\s*\*\* .\+\ \*\*$'&&getline(a:linenum+1)=~'^\s*$'
     return '>1'
  elseif getline(a:linenum)=~'^\s*[0-9]\+ .\+$'&&getline(a:linenum+1)=~'^\s*$'
    return '>1'
  elseif getline(a:linenum)=~'^\s*[0-9]\+\.[0-9]\+ .\+$'&&getline(a:linenum+1)=~'^\s*$'
    return '>2'
  elseif getline(a:linenum)=~'^\s*[0-9]\+\.[0-9]\+\.[0-9]\+ .\+$'&&getline(a:linenum+1)=~'^\s*$'
    return '>3'  
  else
    return '='
  endif
endfunction

set foldexpr=FoldHierarchicalNumbering(v:lnum)
set foldcolumn=2

"Formatting
set formatprg=par

"The following settings provide comfort but are not essential

"Load a nice font
if has("gui_running")
  if has("x11")
     set guifont=Bitstream\ Vera\ Sans\ Mono\ 8 "Linux Font
  else
    set guifont=Consolas                "Windows Font
  endif
  set guioptions-=T                     "Hide Toolbar
endif

if v:version >= 730
  set relativenumber "Show relative line numbers
endif

"How to display unprintable charactes in list mode
"activate with :set list
"default is listchars=eol:$
"set listchars=eol:$,tab:I\\,trail:.,extends:>,precedes:<,conceal:*,nbsp:%
if v:version >= 730 
  set listchars=eol:¶,tab:▸\ ,trail:·,extends:⋯,precedes:⋯,conceal:*,nbsp:%
else
  set listchars=eol:¶,tab:▸\ ,trail:·,extends:⋯,precedes:⋯,nbsp:% 
endif

"Enable menu in console mode
"The following is inspired by the example in :help console-menu
"Use F4 to start menu, select with cursor keys, then Enter or Esc
"TODO I have modified and adapted this from the example, it works,
"but I don't understand it completely.
if !has("gui_running")
  :source $VIMRUNTIME/menu.vim "load menu.vim manually
  :set wildmenu            
  :set cpoptions-=<
  :set wildcharm=<C-Z>
  :map <F4> :emenu <C-Z>
endif

"Statusline
"The statusline is divided into the following sections 
"(from left to right):

"default statusline 
"additional flags: binary and bomb
"fileformat: unix, mac, dos
"filetype 
"separation point for alignment(left=right)
"fileencoding>encoding>termencoding
"tab settings: ts,et,sts,sta, sw 
"position and value of cursor 
"total number of lines 
"default ruler
"
"
"[default statusline]      [encoding]               [character properties]
"file                      fileencoding             position in file              
"  | modified              |     encoding           |     value at cursor    
"  |     |                 |     |     termenc      |     |    
"  |     |                 |     |     |            |     |    
"  |     |                 |     |     |            |     |    
"  |     |                 |     |     |            |     |       [default ruler]       
".vimrc [+][unix][vim]  |utf-8>utf-8|utf-8|8x2s2|000E05=003D| 371/110,3-2        20% 
"            |     |                       |||||               |   |  | |         |
"            |     |                       ||||shiftwidth      |   |  | |         percentage
"            |     |                       |||smarttab         |   |  | column number  
"            |     |                       ||softtabstop       |   |  byte count    
"            |     filetype                |expandtab          |   current line
"            fileformat                    tabstop             total number of lines    
"            [file info]                                       [ruler]
"The leftmost part of the statusline emulates the default statusline,
"which is given in vim help as:
" :set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"From my experience the real default status line is different in two
"aspects:
" 1. It contains the preview flag (%w) right before the help flag
" 2. The behaviour of the modified flag in the default statusline
" is different from what %m and %M do.
"
" modifiable modified default   %m  %M
"          Y        N
"          N        N          [-] ,-
"          Y        Y     [+]  [+] ,+
"          N        Y     [+]  [+-] ,+-
"For my emulation I added the preview flag, but didn't bother
"to implement the default modified behaviour and went with %m
"instead.

set laststatus=2              "always show statusline
set statusline=             "clear statusline
set statusline+=%<            "truncate at the beginning if too long
set statusline+=%f            "relative path and filename
set statusline+=\             "single whitespace (quoted with \)
set statusline+=%w            "preview window flag
set statusline+=%h            "help buffer flag
set statusline+=%m            "modified and modifiable flag
set statusline+=%r            "readonly flag
"Here begins my own statusline
set statusline+=%{&binary?\"[binary]\":\"\"}
set statusline+=%{&bomb?\"[BOM]\":\"\"}
set statusline+=[%{&fileformat}]
              "end of line format: dos <CR> <NL>, unix <NL> or mac <CR>

set statusline+=%y              "filetype

set statusline+=%=           "separation point for alignment(left=right)

" | fileencoding > buffer encoding > terminal encoding |
set statusline+=\|
set statusline+=%{&fileencoding}    "encoding of the file
set statusline+=>
set statusline+=%{&encoding}  "encoding for buffers, registers, 
                              "strings, viminfo
set statusline+=>
set statusline+=%{&termencoding}  "encoding of the terminal

"set statusline+=\|
"set statusline+=%2n              "Buffer number
"set statusline+=\|
"set statusline+=%1{v:register}

" | tabstop expandtab softtabstop shiftwidth |
set statusline+=\|
set statusline+=%-1.1{&tabstop}   "how many columns a tab counts for
set statusline+=%-1.1{&expandtab?\"x\":\"\-\"} "spaces for tab
                                               "real <TAB> with Ctrl-V<TAB>
set statusline+=%-1.1{&softtabstop} "number of spaces for <TAB> and <BS>
set statusline+=%-1.1{&smarttab?\"s\":\"\-\"}   "<TAB> and <BS> is 
                                                "shiftwidth or ts/sts
set statusline+=%-1.1{&shiftwidth} "number of spaces for (auto)indent
set statusline+=\|            "delimiter
set statusline+=%06.8O\=      "byte position in file (starting from 1)
                              "typical is < 16 MiB => ff ffff
                              "largest reasonable is 4 GiB => ffff ffff
set statusline+=%04.6B        "value of current character
                              "typical is 0000 to ffff
                              "largest unicode is 01ffff
set statusline+=\|            "delimiter
set statusline+=%4L/        "Total number of lines in buffer
"The rest of the statusline definition emulates the default ruler
"The default ruler is always 18 characters long, 
"and always starting in column 63.
"The default ruler displayed in the last line is slightly different from
"the default ruler shown in the statusline.
"If the default ruler is in the last line there is always a white space
"in column 80, right after the (three character wide) percentage.
"If the default ruler is displayed in the statusline the three
"characters of the percentage occupy columns 78, 79 and 80.
"Effectively there is one more character of information in the
"default status line ruler than in the default last line ruler.
"For consistency sake my ruler differs from the default in that it
"preserves the space in column 80 even in the statusline.

"The whole ruler is always 18 characters long.
"Line number, byte count in line (contrary to vim help) 
"and column number are combined in a 13 character long group.
set statusline+=%-13.13(%l,%c%V%)
"The percentage is always 3 characters, plus space before and after.
set statusline+=\             "single whitespace (quoted with \)
set statusline+=%P            "percentage through file (always 3 char)
set statusline+=\             "for consistency with the last line ruler


"Useful settings, but disabled by default

"smartindent or cindent should be set automatically by the 
"file type plugin if this does not work they can be set manually
"set smartindent
"set cindent

"set textwidth=72  "was to annoying for website editing

"set background=light

"Based on similar expression from :help fold-expr
"set foldexpr=getline(v:lnum)=~'^\\s*\\*\\*\ .\\+\ \\*\\*$'&&getline(v:lnum+1)=~'^\\s*$'?'>1':1

"set foldmethod=expr  "Folding enabled at startup was annoying


"Load local settings from .vimrc.local
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
