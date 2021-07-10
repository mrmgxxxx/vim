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

" 轻量级自动补全
Plug 'skywind3000/vim-auto-popmenu'

" 代码结构展示
Plug 'preservim/tagbar'

" GOLANG插件
Plug 'fatih/vim-go'
Plug 'volgar1x/vim-gocode'

" Vim状态栏插件，包括显示行号，列号，文件类型，文件名，以及Git状态
Plug 'vim-airline/vim-airline'

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
```

## 主题配色

默认并没有集成主题配色，个人喜好不同，自己配置吧, 推荐（https://github.com/altercation/vim-colors-solarized）

## vim-plug插件管理

参见[vim-plug](https://github.com/junegunn/vim-plug)文档，进行插件的高效管理

## 其他

vim v8.2+ with python3:

```shell
cd /usr/local/share
sudo git clone https://github.com/vim/vim.git
cd vim/src
./configure --enable-pythoninterp=yes --enable-cscope --enable-fontset --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu --enable-python3interp=yes --with-python3-command=python3.6

make
make install
```

`注意`: gcc g++ clang go gofmt等主体工具自己需要用什么就提前安装配置好
