#!/usr/bin/env bash
set -eo pipefail

# install
rootpath=/tmp/mrmgxxxx/vim/
rm -rf $rootpath && mkdir -p $rootpath && cd $rootpath

# install auto commands
run_yum_cmd=0
command -v yum >/dev/null 2>&1 || run_yum_cmd=1
if [ "$run_yum_cmd" -ne 1 ]; then
yum -y install gcc gcc-c++ git wget make clang llvm the_silver_searcher
else
apt-get -y install gcc gcc-c++ git wget make clang llvm silversearcher-ag
fi

# check local vim version
need_install_vim=0
command -v vim >/dev/null 2>&1 || need_install_vim=1
if [ "$need_install_vim" -eq 1 ]; then
    echo -e "\e[34;1mNot found local vim, and need to install now ...\033[0m"
else
    version=`vim --version | head -n 1 | awk -F ' ' '{print $5}'`
    major=`echo $version | awk -F '.' '{print $1}'`
    if [ $major -lt 8 ]; then
        echo -e "\e[34;1mFound local vim version $version, and need to install version 8.0+ now ...\033[0m"
        need_install_vim=1
    else
        echo -e "\e[34;1mLocal vim version $version already installed ...\033[0m"
    fi
fi

# install local new vim
if [ "$need_install_vim" -eq 1 ]; then
    echo -e "\e[34;1mInstall new vim now ...\033[0m"
    git clone https://github.com/vim/vim.git
    cd vim/src && git checkout v8.2.3430

    ./configure --enable-cscope --enable-fontset
    make -j4
    make install

    version=`vim --version | head -n 1 | awk -F ' ' '{print $5}'`
    major=`echo $version | awk -F '.' '{print $1}'`
    if [ $major -lt 8 ]; then
        echo -e "\e[34;1mNew vim install failed !\033[0m"
        exit 1
    else
        echo -e "\e[34;1mNew vim $version installed !\033[0m"
    fi
fi

# install and config vim-plug
rm -rf ~/.vim* && mkdir -p ~/.vim/autoload/
wget -N https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P ~/.vim/autoload/
wget -N https://raw.githubusercontent.com/mrmgxxxx/vim/master/vimrc -O ~/.vimrc

# install fzf
need_install_fzf=0
command -v fzf >/dev/null 2>&1 || need_install_fzf=1
if [ "$need_install_fzf" -eq 1 ]; then
    echo -e "\e[34;1mNot found local fzf command, and need to install now ...\033[0m"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    version=`fzf --version | awk -F ' ' '{print $1}'`
    echo -e "\e[34;1mCommand fzf $version installed !\033[0m"
else
    echo -e "\e[34;1mLocal fzf command already installed ...\033[0m"
fi
