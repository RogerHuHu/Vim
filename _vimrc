set nocompatible   "禁用 Vi 兼容模式
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"------------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
"------------------------------------------------------------------------------
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif

"------------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
"------------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" =============================================================================
"                          << 用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
"set encoding=utf-8                                    "设置gvim内部编码，默认不更改
"set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
filetype off   "禁用文件类型侦测

set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
let path='$VIM/vimfiles/bundle'
call vundle#begin(path)

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" 以下为要安装或更新的插件
Plugin 'a.vim'
Plugin 'majutsushi/tagbar'
Plugin 'The-NERD-tree'
Plugin 'grep.vim'
Plugin 'OmniCppComplete'
Plugin 'The-NERD-Commenter'
Plugin 'AutoComplPop'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set nocp
set completeopt=longest,menu   "关掉智能补全时的预览窗口
filetype on   "开启文件类型侦测
filetype plugin on   "根据侦测到的不同类型加载对应的插件
set lines=30  columns=100   "设置窗口大小
set number   "显示行号
syntax enable   "开启语法高亮功能
syntax on   "语法高亮
set hlsearch   "标记搜索到的字符串
set ignorecase   " 搜索时大小写不敏感
set nocompatible   " 关闭兼容模式
set wildmenu  " vim 自身命令行模式智能补全
filetype indent on   "自适应不同语言的智能缩进
set expandtab   "将制表符扩展为空格
set tabstop=4   "设置编辑时制表符占用的空格数
set shiftwidth=4   "设置格式化时制表符占用的空格数
set softtabstop=4   "让vim把连续数量的空格视为一个制表符
set autoindent
set cindent
set ruler "显示说明
colorscheme maroloccio   "配色方案
set foldmethod=syntax   "基于语法的代码折叠
set nofoldenable   "启动vim时关闭代码折叠

" -----------------------------------------------------------------------------
"  < tagbar.vim >
" -----------------------------------------------------------------------------
nnoremap tb :TagbarToggle<CR>
let tagbar_right=1   "是tagbar在主编辑区的右边
let tagbar_width = 24   "设置tagbar窗口的宽度 
let g:tagbar_compact=1   " tagbar 子窗口中不显示冗余帮助信息

" -----------------------------------------------------------------------------
"  < ctags >
" -----------------------------------------------------------------------------
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"imap <F12> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set tags=tags;
set tags+=./tags;
set autochdir

" -----------------------------------------------------------------------------
"  < minibufexpl.vim >
" -----------------------------------------------------------------------------
"多文档编辑
let g:miniBufExplMapWindowNavVim = 1   "按下Ctrl+h/j/k/l，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapWindowNavArrows = 1  "按下Ctrl+箭头，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapCTabSwitchBufs = 1   "启用以下两个功能：Ctrl+tab移到下一个窗口
let g:miniBufExplModSelTarget = 1  "不要在不可编辑内容的窗口（如TagList窗口）中打开选中的buffer

" -----------------------------------------------------------------------------
"  < NERD-tree.vim >
" -----------------------------------------------------------------------------
nmap fl :NERDTreeToggle<CR>   " 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
let NERDTreeWinSize=24   " 设置NERDTree子窗口宽度
let NERDTreeWinPos="left"   " 设置NERDTree子窗口位置
let NERDTreeShowHidden=1   " 显示隐藏文件
let NERDTreeMinimalUI=1   " NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeAutoDeleteBuffer=1   " 删除文件时自动删除文件对应 buffer

" -----------------------------------------------------------------------------
"  < grep.vim >
" -----------------------------------------------------------------------------
nnoremap <silent> <F3> :Grep<CR>   "在工程中快速查找

" -----------------------------------------------------------------------------
"  < a.vim >
" -----------------------------------------------------------------------------
nnoremap <silent> <F12> :A<CR>   "h\c切换（头文件和源文件切换）

" -----------------------------------------------------------------------------
"  < omnicppcomplete.vim >
" -----------------------------------------------------------------------------
set tags+=C:/stl_tags;
set completeopt=menu,menuone  
let OmniCpp_MayCompleteDot=1    "打开  . 操作符
let OmniCpp_MayCompleteArrow=1  "打开 -> 操作符
let OmniCpp_MayCompleteScope=1  "打开 :: 操作符
let OmniCpp_NamespaceSearch=1   "打开命名空间
let OmniCpp_GlobalScopeSearch=1  
let OmniCpp_DefaultNamespace=["std"]  
let OmniCpp_ShowPrototypeInAbbr=1  "打开显示函数原型
let OmniCpp_SelectFirstItem = 2"自动弹出时自动跳至第一个
"let OmniCpp_DisplayMode=1；  "类成员显示控制(是否显示全部公有(public)私有(private)保护(protected)成员)

" -----------------------------------------------------------------------------
"  < DoxygenToolkit.vim >
" -----------------------------------------------------------------------------
let g:DoxygenToolkit_briefTag_pre="\\brief " 
let g:DoxygenToolkit_paramTag_pre="\\param " 
let g:DoxygenToolkit_returnTag="\\return " 
let g:DoxygenToolkit_startCommentTag="/************************************************"
let g:DoxygenToolkit_endCommentTag="***********************************************/"
let g:DoxygenToolkit_startCommentBlock = "/* "
let g:DoxygenToolkit_endCommentBlock = "*/"

"------------------------------------------------------------------------------
"  < 编译、连接、运行配置 >
"------------------------------------------------------------------------------
" F5 一键保存、编译、连接存并运行
map <F5> :call Run()<CR>
" imap <F5> <ESC>:call Run()<CR>

" Ctrl + F5 一键保存并编译
map <c-F5> :call Compile()<CR>
" imap <c-F5> <ESC>:call Compile()<CR>

" F6 一键保存并连接
map <F6> :call Link()<CR>
" imap <F6> <ESC>:call Link()<CR>

" 调试 F7
map <F7> :call Debug()<CR>

let s:LastShellReturn_C = 0
let s:LastShellReturn_L = 0
let s:ShowWarning = 1
let s:Obj_Extension = '.o'
let s:Exe_Extension = '.exe'
let s:Sou_Error = 0

let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

func! Compile()
    exe ":ccl"
    exe ":update"
    if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        let Obj_Name = expand("%:p:t:r").s:Obj_Extension
        let v:statusmsg = ''
        if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
            redraw!
            if expand("%:e") == "c"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CFlags
                else
                    exe ":setlocal makeprg=".s:linux_CFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                if g:iswindows
                    exe ":setlocal makeprg=".s:windows_CPPFlags
                else
                    exe ":setlocal makeprg=".s:linux_CPPFlags
                endif
                echohl WarningMsg | echo " compiling..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_C = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_C != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " compilation failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " compilation successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " compilation successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Obj_Name"is up to date"
        endif
    else
        let s:Sou_Error = 1
        echohl WarningMsg | echo " please choose the correct source file"
    endif
    exe ":setlocal makeprg=make"
endfunc

func! Link()
    call Compile()
    if s:Sou_Error || s:LastShellReturn_C != 0
        return
    endif
    let s:LastShellReturn_L = 0
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
        let Exe_Name = expand("%:p:t:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
        let Exe_Name = expand("%:p:t:r")
    endif
    let v:statusmsg = ''
	if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        redraw!
        if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
            if expand("%:e") == "c"
                setlocal makeprg=gcc\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                setlocal makeprg=g++\ -o\ %<\ %<.o
                echohl WarningMsg | echo " linking..."
                silent make
            endif
            redraw!
            if v:shell_error != 0
                let s:LastShellReturn_L = v:shell_error
            endif
            if g:iswindows
                if s:LastShellReturn_L != 0
                    exe ":bo cope"
                    echohl WarningMsg | echo " linking failed"
                else
                    if s:ShowWarning
                        exe ":bo cw"
                    endif
                    echohl WarningMsg | echo " linking successful"
                endif
            else
                if empty(v:statusmsg)
                    echohl WarningMsg | echo " linking successful"
                else
                    exe ":bo cope"
                endif
            endif
        else
            echohl WarningMsg | echo ""Exe_Name"is up to date"
        endif
    endif
    setlocal makeprg=make
endfunc

func! Run()
    let s:ShowWarning = 0
    call Link()
    let s:ShowWarning = 1
    if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
        return
    endif
    let Sou = expand("%:p")
    let Obj = expand("%:p:r").s:Obj_Extension
    if g:iswindows
        let Exe = expand("%:p:r").s:Exe_Extension
    else
        let Exe = expand("%:p:r")
    endif
    if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
        redraw!
        echohl WarningMsg | echo " running..."
        if g:iswindows
            exe ":!%<.exe"
        else
            if g:isGUI
                exe ":!gnome-terminal -e ./%<"
            else
                exe ":!./%<"
            endif
        endif
        redraw!
        echohl WarningMsg | echo " running finish"
    endif
endfunc

"定义Debug函数，用来调试程序
func Debug()
exec "w"

if &filetype == 'c'
exec "!gcc % -g -o %<.exe"
exec "!gdb %<.exe"
elseif &filetype == 'cpp'
exec "!g++ % -g -o %<.exe"
exec "!gdb %<.exe"
elseif &filetype == 'java'
exec "!javac %"
exec "!jdb %<"
endif
endfunc
