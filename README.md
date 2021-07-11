vim插件整理

## 依赖

- vim8: 仅支持vim version 8+版本;
- ctags: 用于生成符号列表;

## 安装
>安装之前自行备份好旧配置，清理HOME目录下的所有以`.vim`起始的文件和目录，以免新旧配置相关影响效果

```shell
sh install.sh
```

## 默认集成插件

```shell
" 目录树
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" 目录树导航优化
Plug 'jistr/vim-nerdtree-tabs'

" 目录树导航GIT信息
Plug 'Xuyuanp/nerdtree-git-plugin'

" 文件查找
Plug 'kien/ctrlp.vim'

" 自动生成ctags
Plug 'ludovicchabant/vim-gutentags'

" 多语言语法纠错
Plug 'vim-syntastic/syntastic'

" CPP语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'

" 代码结构展示
Plug 'preservim/tagbar'

" GOLANG插件
Plug 'fatih/vim-go'
Plug 'volgar1x/vim-gocode'

" 状态栏插件
Plug 'vim-airline/vim-airline'

" 简单自动补全
Plug 'maxboisvert/vim-simple-complete'

" LeaderF搜索
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" Markdown插件
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'

" 代码GIT提交信息插件
Plug 'zivyangll/git-blame.vim'

" JSON插件
Plug 'elzr/vim-json'

" 显示多余空格
Plug 'ntpeters/vim-better-whitespace'

" 自动对齐
Plug 'godlygeek/tabular'

" solarized
Plug 'altercation/vim-colors-solarized'

" codedark
Plug 'tomasiser/vim-code-dark'
```

## 依赖安装

vim v8.2+ with python3:

```shell
git clone https://github.com/vim/vim.git
cd vim/src
./configure --enable-pythoninterp=yes --enable-cscope --enable-fontset --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu --enable-python3interp=yes --with-python3-command=python3.6

make
make install
```

`注意`: gcc/g++/clang/go等主体工具自己需要用什么就提前安装配置好

## 使用介绍
>每个人配置不同，使用习惯不同，这里记下这套配置的使用方式

`项目管理`:

默认配置了`['.root', '.svn', '.git', '.project', '.vimex', '.vim']`项目文件列表，打开vim时会从当前目录开始向上递归查找这些文件，找到任意一个目标文件后则停止查找，并以找到位置作为项目根目录，后续任何源文件变动都会基于vim8的异步机制为项目实时生成tags，作为跳转和代码结构展示的依据。

生成的tags根据配置会保存在~/.cache下，并以你的项目路径作为名词规则，这样不会污染你的项目目录数据。整体的效果就是：无需手动执行ctags命令，只要目录中有特定的project文件即可自动完成生成，使用者无需关心修改完代码后的更新问题。

`文件查找`:

很多人不喜欢CtrlP，但我比较喜欢它的简洁，ctrl+p即可模糊搜索文件，还比较顺手。

`全能搜索`：

集成了LeaderF查找工具，这个插件比较全面，可以查找文件、变量、关键字等任何想要搜索的，并且支持各种匹配规则的查找。

默认集成基于rg命令的搜索，这个命令在各个平台操作系统中都有编译好的二进制，我也放了一个在仓库中，可以直接放到你的bin下。
LeaderF功能很强大，可以根据需求自行配置快捷键。默认的我设置了<Leader>gg作为快速查找光标下内容的快捷键。

`目录树`：

按<F3>即可打开目录树，并且目录树中会以不同图标显示Git信息，当发生改动时会在对应的文件或目录上显示特定图标以提醒你这里发生变动。

`代码结构展示`：

按<F4>即可在右侧打开当前源文件的代码结构列表，展示出变量、函数等tags信息。

`Go代码提示`:

按<F6>可以进行Go语言代码提示，也可以配置输入`.`时自动提示，默认关闭了这个，因为我个人不喜欢过度的代码提示，如果需要可以放开。

`语法纠错`：

语法纠错没有使用ALE而是使用经典的syntastic, 主要还是比较好管理好配置。并且它也支持多语言纠错。
目前在编写C、C++、Go时都会在保存时（:w）触发检查，进行语法纠错，出现错误时会在指定代码行位置和quickfix窗口提示错误信息。

可以针对自己的喜好配置各种错误信息提示的图标和配色，也可以根据项目结构自定义头文件位置以便于精确的进行检查。

`语法高亮`：

很多时候默认配色的语法高亮不准确，特别是C++，故此针对性的做了C++的语法高亮，尽量的准确显示，以便于清晰展示代码结构。

`其他小功能`：

JSON、Markdown、自动对齐、匹配显示等等小插件，都比较轻量，也可以根据自己喜好增减插件，基于Vim-Plug的插件管理很方便很高效。

## 主题配色

默认集成了VSCode深色主题，可以自己配置，基于Vim-Plug很简单:

![avatar](https://cloud.githubusercontent.com/assets/10374559/23341312/1961f416-fc45-11e6-83ba-d7180c5fdd6d.png)

`个人推荐配色`:https://github.com/altercation/vim-colors-solarized

## vim-plug插件管理

参见[vim-plug](https://github.com/junegunn/vim-plug)文档，进行插件的高效管理
