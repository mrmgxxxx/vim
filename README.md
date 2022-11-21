Vim8插件配置整理(已经返璞归真，插件越用越少了)
==============================================

安装之前自行备份并清理HOME目录下的所有以`.vim`起始的文件和目录，以免新旧配置相关影响效果。

## vim8 + vim-plug

安装vim8.2:

```shell
git clone https://github.com/vim/vim.git
cd vim/src && git checkout v8.2.3430

./configure --enable-cscope --enable-fontset --enable-python3interp=yes --with-python3-command=python3.6
make && make install
```

安装[vim-plug插件管理工具](https://github.com/junegunn/vim-plug):

```shell
mkdir -p ~/.vim/autoload/
wget -P ~/.vim/autoload/ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

拷贝vim配置文件到HOME目录:

```shell
cp -rf vimrc ~/.vimrc
```

打开vim并输入':PlugInstall'将自动安装所有插件。

## 安装fzf(搜索插件依赖)

安装ag：

```shell
// https://github.com/ggreer/the_silver_searcher
yum install the_silver_searcher
```

安装fzf：

```shell
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## 安装llvm/clang(代码格式化与分析依赖)

```shell
yum -y install clang
yum -y install llvm
```

## 主题配色

默认集成了Base16系列深色主题，可以自己配置，基于Vim-Plug很简单:

![avatar](https://cloud.githubusercontent.com/assets/10374559/23341312/1961f416-fc45-11e6-83ba-d7180c5fdd6d.png)

`个人推荐配色`:https://github.com/altercation/vim-colors-solarized

> solarized深色主题若发现背景灰色，可通过这三个设置项尝试修复`let g:solarized_termcolors=256`, `let g:solarized_termcolors=16`, `let g:solarized_termtrans=1`

`终端配色推荐`: `Foreground: 00f900`, `Background: 002b36`

`终端命令提示符推荐`: `export PS1='\[\e[32;1m\][\u@\h \W]\\$> \[\e[0m\]'`
