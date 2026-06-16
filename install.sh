#!/usr/bin/env bash
set -eo pipefail

# colored echo helper
say() { echo -e "\e[34;1m$1\033[0m"; }

# use sudo only when not already root
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    command -v sudo >/dev/null 2>&1 || { say "😭  Need root or sudo to install packages!"; exit 1; }
    SUDO="sudo"
fi

# make install workspace (unique per run to avoid /tmp clashes)
rootpath=$(mktemp -d "${TMPDIR:-/tmp}/mrmgxxxx-vim.XXXXXX")
logfile="$rootpath/install.log"
trap 'echo "see log: $logfile"' ERR

# install base commands
# vim compile deps: ncurses dev headers are required by ./configure
if command -v yum >/dev/null 2>&1; then
    $SUDO yum -y install gcc git wget make clang llvm ncurses-devel the_silver_searcher >> "$logfile" 2>&1
elif command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get -y update >> "$logfile" 2>&1
    $SUDO apt-get -y install gcc git wget make clang llvm libncurses-dev silversearcher-ag >> "$logfile" 2>&1
else
    say "😭  No supported package manager (yum/apt-get) found!"
    exit 1
fi
say "🌈  Commands gcc/git/wget/make/clang/llvm/ag install successfully!\n"

# check local vim version
need_install_vim=0
if ! command -v vim >/dev/null 2>&1; then
    say "😥  Not found vim, need to install one ..."
    need_install_vim=1
else
    version=$(vim --version | head -n 1 | awk '{print $5}')
    major=$(echo "$version" | awk -F '.' '{print $1}')

    if [ "${major:-0}" -lt 8 ]; then
        say "🐱  Found local vim version $version which need to upgrade version to 8.0+ ..."
        need_install_vim=1
    else
        say "👀  Local vim version $version is already installed!"
    fi
fi

# install local new vim
if [ "$need_install_vim" -eq 1 ]; then
    say "🐱  Install the new vim version now (it may take some time to compile, please be patient) ..."
    cd "$rootpath"
    git clone https://github.com/vim/vim.git >> "$logfile" 2>&1
    cd vim/src && git checkout v8.2.3430 >> "$logfile" 2>&1

    ./configure --with-features=huge --enable-cscope --enable-fontset >> "$logfile" 2>&1
    make -j"$(nproc)" >> "$logfile" 2>&1
    $SUDO make install >> "$logfile" 2>&1

    # forget cached PATH lookups so the freshly installed vim is picked up
    hash -r 2>/dev/null || true

    if ! command -v vim >/dev/null 2>&1; then
        say "😭  New vim version install failed!\n"
        exit 1
    fi

    version=$(vim --version | head -n 1 | awk '{print $5}')
    major=$(echo "$version" | awk -F '.' '{print $1}')

    if [ "${major:-0}" -lt 8 ]; then
        say "😭  New vim version install failed!\n"
        exit 2
    else
        say "🌈  New vim version $version install successfully!\n"
    fi
fi

# install fzf
if ! command -v fzf >/dev/null 2>&1 && [ ! -x "${HOME}/.fzf/bin/fzf" ]; then
    say "😥  Not found fzf command, install now ..."
    rm -rf "${HOME}/.fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf" >> "$logfile" 2>&1
    "${HOME}/.fzf/install" --all >> "$logfile" 2>&1

    # validate via the full path (current shell PATH may not be updated yet)
    if [ ! -x "${HOME}/.fzf/bin/fzf" ]; then
        say "😭  Command fzf install failed!\n"
        exit 1
    fi

    version=$("${HOME}/.fzf/bin/fzf" --version | awk '{print $1}')
    say "🌈  Command fzf $version install successfully!\n"
else
    say "👀  Local fzf command is already installed!"
fi

# check local vim-plug / .vimrc
need_config_vim=0
wget -N https://raw.githubusercontent.com/mrmgxxxx/vim/master/vimrc -P "$rootpath" >> "$logfile" 2>&1
if [ -f "${HOME}/.vimrc" ]; then
    newFile=$(md5sum "$rootpath/vimrc" | awk '{print $1}')
    curFile=$(md5sum "${HOME}/.vimrc" | awk '{print $1}')

    if [ "$newFile" != "$curFile" ]; then
        say "😥  The ${HOME}/.vimrc file is not correct, reconfig vim-plug now ..."
        need_config_vim=1
    else
        say "👀  The vim-plug is already configed!"
    fi
else
    say "😥  Not found ${HOME}/.vimrc file, reconfig vim-plug now ..."
    need_config_vim=1
fi

# config vim-plug
if [ "$need_config_vim" -eq 1 ]; then
    # remove only the paths we manage, not every ~/.vim* dotfile
    rm -rf "${HOME}/.vim" "${HOME}/.vimrc"
    mkdir -p "${HOME}/.vim/autoload/"
    wget -N https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P "${HOME}/.vim/autoload/" >> "$logfile" 2>&1
    cp -f "$rootpath/vimrc" "${HOME}/.vimrc"
    say "🌈  Install and config vim-plug successfully!\n"

    # make the vim config effect(the workflow may be broken and stop if not do this at end)
    vim +silent +PlugInstall +qall --not-a-term
fi

say "\n\t 🐸 🐸 🐸  Enjoy It ~ 🐸 🐸 🐸 \n"
