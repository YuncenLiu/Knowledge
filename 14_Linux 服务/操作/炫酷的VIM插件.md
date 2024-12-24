

来源：[CSDN](https://blog.csdn.net/eighters/article/details/137343162)

编辑本地 `~/.vimrc` 文件



需要用 LF 作为存储格式

```
set tabstop=4
set backspace=2
set shiftwidth=4
set softtabstop=4
set noexpandtab
set nowrap
set nu
syntax on                       " 语法高亮
set ruler                       " 显示标尺
set showcmd                     " 输入的命令显示出来，看的清楚些
set cmdheight=1                 " 命令行（在状态行下）的高度，设置为1
set scrolloff=3                 " 光标移动到buffer的顶部和底部时保持3行距离
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   " 状态行显示的内容
set laststatus=2                " 启动显示状态行(1),总是显示状态行(2)
set nocompatible                " 去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
 
" 设置当文件被改动时自动载入
set autoread
" 代码补全
set completeopt=preview,menu
" 突出显示当前行
set cursorline
" 在处理未保存或只读文件的时候，弹出确认
set confirm
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
au BufRead,BufNewFile *  setfiletype txt
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call SetTitle()"
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G
""定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\#    File Name: ".expand("%"))
        call append(line(".")+1, "\#    Author: eight")
        call append(line(".")+2, "\#    Mail: 18847097110@163.com ")
        call append(line(".")+3, "\#    Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "RED='\\E[1;31m'")
        call append(line(".")+7, "GREEN='\\E[1;32m'")
        call append(line(".")+8, "RES='\\E[0m'")
        call append(line(".")+9, "")
    endif
    if &filetype == 'python'
        call setline(1,"\#########################################################################")
        call append(line("."), "\#    File Name: ".expand("%"))
        call append(line(".")+1, "\#    Author: eight")
        call append(line(".")+2, "\#    Mail: 18847097110@163.com ")
        call append(line(".")+3, "\#    Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/usr/bin/env python")
        call append(line(".")+6, "\# -*- coding: utf-8 -*-")
        call append(line(".")+7, "")
    endif
endfunc
 
 
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口
let Tlist_Compart_Format = 1    " 压缩方式
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer
let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags
let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树
let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags
set tags=tags
"set autochdir
```

