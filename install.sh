#!/usr/bin/env bash
set -eo pipefail

# output helpers (step counter + unified symbols)
if [ -t 2 ]; then
    C_BOLD=$'\e[1m'; C_DIM=$'\e[2m'; C_BLUE=$'\e[34;1m'
    C_GREEN=$'\e[32;1m'; C_RED=$'\e[31;1m'; C_RESET=$'\e[0m'
else
    C_BOLD=""; C_DIM=""; C_BLUE=""; C_GREEN=""; C_RED=""; C_RESET=""
fi

STEP_NO=0
STEP_TOTAL=0

# step "description" -- prints a numbered step header
step() {
    STEP_NO=$((STEP_NO + 1))
    printf '%s==>%s %s[%d/%d]%s %s\n' \
        "$C_BLUE" "$C_RESET" "$C_BOLD" "$STEP_NO" "$STEP_TOTAL" "$C_RESET" "$1" >&2
}

# info "message"  -- a plain sub-line under a step
info() { printf '    %s%s%s\n' "$C_DIM" "$1" "$C_RESET" >&2; }

# skip "message"  -- marks something already done / skipped
skip() { printf '    %s\u2022%s %s\n' "$C_DIM" "$C_RESET" "$1" >&2; }

# ok "message"    -- a success sub-line (no timing)
ok() { printf '    %s\u2714%s %s\n' "$C_GREEN" "$C_RESET" "$1" >&2; }

# fail "message"  -- print an error and exit
fail() {
    printf '    %s\u2718%s %s\n' "$C_RED" "$C_RESET" "$1" >&2
    printf '    %ssee log: %s%s\n' "$C_DIM" "$logfile" "$C_RESET" >&2
    exit 1
}

# run_step "description" cmd args...
# runs the command in background (output appended to $logfile), shows a spinner
# while it runs, then prints elapsed time; exits on failure.
run_step() {
    local desc="$1"; shift
    local start=$SECONDS

    "$@" >> "$logfile" 2>&1 &
    local pid=$!

    if [ -t 2 ]; then
        local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local i=0
        while kill -0 "$pid" 2>/dev/null; do
            i=$(( (i + 1) % ${#frames} ))
            printf '\r    %s%s%s %s' "$C_BLUE" "${frames:$i:1}" "$C_RESET" "$desc" >&2
            sleep 0.1
        done
    else
        printf '    %s... %s\n' "$C_DIM" "$desc" >&2
    fi

    if wait "$pid"; then
        printf '\r    %s\u2714%s %s %s(%ds)%s\033[K\n' \
            "$C_GREEN" "$C_RESET" "$desc" "$C_DIM" "$((SECONDS - start))" "$C_RESET" >&2
    else
        printf '\r    %s\u2718%s %s %s(%ds)%s\033[K\n' \
            "$C_RED" "$C_RESET" "$desc" "$C_DIM" "$((SECONDS - start))" "$C_RESET" >&2
        fail "step failed: $desc"
    fi
}

# preflight
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    command -v sudo >/dev/null 2>&1 || { printf '%s\u2718%s need root or sudo to install packages\n' "$C_RED" "$C_RESET" >&2; exit 1; }
    SUDO="sudo"
fi

# make install workspace (unique per run to avoid /tmp clashes)
rootpath=$(mktemp -d "${TMPDIR:-/tmp}/mrmgxxxx-vim.XXXXXX")
logfile="$rootpath/install.log"
trap 'echo "see log: $logfile"' ERR

# probe what needs to be done, so the [n/N] counter is accurate
# step 1: base packages (always)
STEP_TOTAL=$((STEP_TOTAL + 1))

# step 2: vim (only if missing or < 8)
need_install_vim=0
if ! command -v vim >/dev/null 2>&1; then
    need_install_vim=1
else
    _vimver=$(vim --version | head -n 1 | awk '{print $5}')
    _vimmajor=$(echo "$_vimver" | awk -F '.' '{print $1}')
    [ "${_vimmajor:-0}" -lt 8 ] && need_install_vim=1
fi
[ "$need_install_vim" -eq 1 ] && STEP_TOTAL=$((STEP_TOTAL + 1))

# step 3: fzf (only if missing)
need_install_fzf=0
if ! command -v fzf >/dev/null 2>&1 && [ ! -x "${HOME}/.fzf/bin/fzf" ]; then
    need_install_fzf=1
    STEP_TOTAL=$((STEP_TOTAL + 1))
fi

# step 4: vim-plug / vimrc (always run the config step; it is idempotent)
STEP_TOTAL=$((STEP_TOTAL + 1))

printf '%s%sSetting up Vim8 environment%s %s(%d steps)%s\n' \
    "$C_BOLD" "$C_BLUE" "$C_RESET" "$C_DIM" "$STEP_TOTAL" "$C_RESET" >&2

# step: base commands
step "Installing base packages"
if command -v yum >/dev/null 2>&1; then
    run_step "gcc git make clang ncurses-devel the_silver_searcher" \
        $SUDO yum -y install gcc git make clang ncurses-devel the_silver_searcher
elif command -v apt-get >/dev/null 2>&1; then
    run_step "updating apt package index" $SUDO apt-get -y update
    run_step "gcc git make clang libncurses-dev silversearcher-ag" \
        $SUDO apt-get -y install gcc git make clang libncurses-dev silversearcher-ag
else
    fail "no supported package manager (yum/apt-get) found"
fi

# step: vim
if [ "$need_install_vim" -eq 1 ]; then
    step "Installing Vim 8.2 from source"
    cd "$rootpath"
    run_step "cloning vim source" git clone https://github.com/vim/vim.git
    cd vim/src
    run_step "checking out v8.2.3430" git checkout v8.2.3430
    run_step "compiling vim (this may take a few minutes)" \
        bash -c './configure --with-features=huge --enable-cscope --enable-fontset && make -j"$(nproc)"'
    run_step "installing vim" $SUDO make install

    # forget cached PATH lookups so the freshly installed vim is picked up
    hash -r 2>/dev/null || true

    if ! command -v vim >/dev/null 2>&1; then
        fail "new vim install failed"
    fi

    version=$(vim --version | head -n 1 | awk '{print $5}')
    major=$(echo "$version" | awk -F '.' '{print $1}')
    if [ "${major:-0}" -lt 8 ]; then
        fail "new vim install failed (version $version)"
    else
        ok "vim $version installed"
    fi
else
    skip "vim $_vimver already installed"
fi

# step: fzf
if [ "$need_install_fzf" -eq 1 ]; then
    step "Installing fzf"
    rm -rf "${HOME}/.fzf"
    run_step "cloning fzf" git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
    run_step "running fzf installer" "${HOME}/.fzf/install" --all

    if [ ! -x "${HOME}/.fzf/bin/fzf" ]; then
        fail "fzf install failed"
    fi
    version=$("${HOME}/.fzf/bin/fzf" --version | awk '{print $1}')
    ok "fzf $version installed"
else
    skip "fzf already installed"
fi

# step: vim-plug / vimrc
step "Configuring vim-plug and .vimrc"
run_step "fetching vimrc" \
    curl -fsSL https://raw.githubusercontent.com/mrmgxxxx/vim/master/vimrc -o "$rootpath/vimrc"

need_config_vim=0
if [ -f "${HOME}/.vimrc" ]; then
    newFile=$(md5sum "$rootpath/vimrc" | awk '{print $1}')
    curFile=$(md5sum "${HOME}/.vimrc" | awk '{print $1}')
    if [ "$newFile" != "$curFile" ]; then
        info "existing .vimrc differs, reconfiguring"
        need_config_vim=1
    else
        skip ".vimrc already up to date"
    fi
else
    info "no .vimrc found, configuring"
    need_config_vim=1
fi

if [ "$need_config_vim" -eq 1 ]; then
    rm -rf "${HOME}/.vim" "${HOME}/.vimrc"
    mkdir -p "${HOME}/.vim/autoload/"
    run_step "installing vim-plug" \
        curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o "${HOME}/.vim/autoload/plug.vim"
    cp -f "$rootpath/vimrc" "${HOME}/.vimrc"
    run_step "installing plugins (PlugInstall)" \
        vim +silent +PlugInstall +qall --not-a-term
    ok "vim-plug configured"
fi

# done
printf '\n%s\u2714 Done.%s Vim environment is ready.\n' "$C_GREEN$C_BOLD" "$C_RESET" >&2
