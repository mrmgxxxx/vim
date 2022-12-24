#!/usr/bin/env bash
set -eo pipefail

# make install
rootpath=/tmp/mrmgxxxx/vim/
rm -rf $rootpath && mkdir -p $rootpath

# install base commands
run_yum_cmd=0
command -v yum >/dev/null 2>&1 || run_yum_cmd=1
if [ "$run_yum_cmd" -ne 1 ]; then
yum -y install gcc git wget make clang llvm the_silver_searcher >> $rootpath/install.log 2>&1
else
apt-get -y install gcc git wget make clang llvm silversearcher-ag >> $rootpath/install.log 2>&1
fi
echo -e "\e[34;1m🌈  Commands gcc/git/wget/make/clang/llvm/ag install successfully!\033[0m"

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
        echo -e "\e[34;1m👀  Local vim version $version is already installed!\033[0m"
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
        echo -e "\e[34;1m😭  New vim version install failed!\033[0m"
        exit 1
    else
        echo -e "\e[34;1m🌈  New vim version $version install successfully!\033[0m"
    fi
fi

# check local vim-plug
cd $rootpath
need_config_vim=0
wget -N https://raw.githubusercontent.com/mrmgxxxx/vim/master/vimrc >> $rootpath/install.log 2>&1
if [ -f "${HOME}/.vimrc" ]; then
    newFile=`md5sum $rootpath/vimrc | awk -F ' ' '{print $1}'`
    curFile=`md5sum ${HOME}/.vimrc | awk -F ' ' '{print $1}'`
    if [ "$newFile" != "$curFile" ]; then
        echo -e "\e[34;1m😥  The ${HOME}/.vimrc file is not correct, reconfig vim-plug now ...\033[0m"
        need_config_vim=1
    else
        echo -e "\e[34;1m👀  The vim-plug is already configed!\033[0m"
    fi
else
    echo -e "\e[34;1m😥  Not found ${HOME}/.vimrc file, reconfig vim-plug now ...\033[0m"
    need_config_vim=1
fi

# config vim-plug
cd $rootpath
if [ "$need_config_vim" -eq 1 ]; then
    rm -rf ~/.vim* && mkdir -p ~/.vim/autoload/
    wget -N https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P ~/.vim/autoload/ >> $rootpath/install.log 2>&1
    cp -rf $rootpath/vimrc ${HOME}/.vimrc
    echo -e "\e[34;1m🌈  Install and config vim-plug successfully!\033[0m"
fi

# install fzf
need_install_fzf=0
command -v fzf >/dev/null 2>&1 || need_install_fzf=1
if [ "$need_install_fzf" -eq 1 ]; then
    echo -e "\e[34;1m😥  Not found fzf command, install now ...\033[0m"
    cd $rootpath
    rm -rf ~/.fzf*
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >> $rootpath/install.log 2>&1
    ~/.fzf/install --all >> $rootpath/install.log 2>&1
    version=`fzf --version | awk -F ' ' '{print $1}'`
    echo -e "\e[34;1m🌈  Command fzf $version install successfully!\033[0m"
else
    echo -e "\e[34;1m👀  Local fzf command is already installed!\033[0m"
fi

echo -e "\e[34;1m\n🐸  Enjoy It ~ \n \033[0m"
