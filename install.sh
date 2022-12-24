#!/usr/bin/env bash
set -eo pipefail

# make install
rootpath=/tmp/mrmgxxxx/vim/
rm -rf $rootpath && mkdir -p $rootpath

# install auto commands
run_yum_cmd=0
command -v yum >/dev/null 2>&1 || run_yum_cmd=1
if [ "$run_yum_cmd" -ne 1 ]; then
yum -y install gcc git wget make clang llvm the_silver_searcher >> $rootpath/install.log 2>&1
else
apt-get -y install gcc git wget make clang llvm silversearcher-ag >> $rootpath/install.log 2>&1
fi
echo -e "\e[34;1m🌈  Commands gcc git wget make clang llvm ag install successfully !\033[0m"

# check local vim version
need_install_vim=0
command -v vim >/dev/null 2>&1 || need_install_vim=1
if [ "$need_install_vim" -eq 1 ]; then
    echo -e "\e[34;1m😥  Not found vim, need to install one ...\033[0m"
else
    version=`vim --version | head -n 1 | awk -F ' ' '{print $5}'`
    major=`echo $version | awk -F '.' '{print $1}'`
    if [ $major -lt 8 ]; then
        echo -e "\e[34;1m🐱  Found local vim version $version which need to upgrade version to 8.0+ ...\033[0m"
        need_install_vim=1
    else
        echo -e "\e[34;1m👀  Local vim version $version already installed ...\033[0m"
    fi
fi

# install local new vim
if [ "$need_install_vim" -eq 1 ]; then
    echo -e "\e[34;1m🐱  Install the new vim version now ...\033[0m"
    cd $rootpath
    git clone https://github.com/vim/vim.git >> $rootpath/install.log 2>&1
    cd vim/src && git checkout v8.2.3430 >> $rootpath/install.log 2>&1

    ./configure --enable-cscope --enable-fontset >> $rootpath/install.log 2>&1
    make -j4 >> $rootpath/install.log 2>&1
    make install >> $rootpath/install.log 2>&1

    version=`vim --version | head -n 1 | awk -F ' ' '{print $5}'`
    major=`echo $version | awk -F '.' '{print $1}'`
    if [ $major -lt 8 ]; then
        echo -e "\e[34;1m😭  New vim version install failed !\033[0m"
        exit 1
    else
        echo -e "\e[34;1m🌈  New vim version $version install successfully !\033[0m"
    fi
fi

# install and config vim-plug
cd $rootpath
rm -rf ~/.vim* && mkdir -p ~/.vim/autoload/
wget -N https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P ~/.vim/autoload/ >> $rootpath/install.log 2>&1
wget -N https://raw.githubusercontent.com/mrmgxxxx/vim/master/vimrc -O ~/.vimrc >> $rootpath/install.log 2>&1

# install fzf
need_install_fzf=0
command -v fzf >/dev/null 2>&1 || need_install_fzf=1
if [ "$need_install_fzf" -eq 1 ]; then
    echo -e "\e[34;1m😥  Not found fzf command, and need to install now ...\033[0m"
    cd $rootpath
    rm -rf ~/.fzf*
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >> $rootpath/install.log 2>&1
    ~/.fzf/install --all >> $rootpath/install.log 2>&1
    version=`fzf --version | awk -F ' ' '{print $1}'`
    echo -e "\e[34;1m🌈  Command fzf $version installed !\033[0m"
else
    echo -e "\e[34;1m👀  Local fzf command already installed ...\033[0m"
fi

echo -e "\e[34;1m\n🐸  Enjoy It ~ \n \033[0m"
