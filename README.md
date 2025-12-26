🐸 Personal Vim8 Settings
=========================

Before installation, backup and clean all files and directories starting with '.vim' in the HOME directory to avoid effects related to the old and new configurations.

Recommended OS is CentOS 8 which have Clang 11+, GCC 7+/8+, and you also could install universal ctags(https://github.com/universal-ctags/ctags) by your self for more ctag features.

**👀 Install:**

Run the command to install and config your vim shit ~

```sh
sudo wget -O - https://raw.githubusercontent.com/mrmgxxxx/vim/master/install.sh | sh
```

🍺 Recommended Color:

```
Foreground: 00f900
Background: 002b36
```

🍟 Recommended Terminal:

```sh
export PS1='\[\e[32;1m\][\u@\h \W]\\$> \[\e[0m\]'
```

🍉 Recommended .gitconfig:

```
[color]
    branch = auto
    ui = auto
    status = auto
[alias]
    st = status
    co = checkout

    # show the file commit log graph base on 'git log'
    ll = log --graph --abbrev-commit --decorate --format=format:'%C(red)%h%C(reset) - %C(bold yellow)%d%C(reset) %C(bold green)%s%C(reset) %C(blue)- %an%C(reset) %C(blue)%aD%C(reset) %C(blue)(%ar)%C(reset)' --all

    # show the file line commit base on 'git blame' and 'git log',
    # e.g.: git lb 42 example.cpp
    lb = "!f() { \
        commit_hash=$(git blame -L $1,$1 \"$2\" 2>/dev/null | awk \"{print \\$1}\" | head -1); \
        if [ -z \"$commit_hash\" ] || [ \"$commit_hash\" = \"^\" ]; then \
            return 1; \
        fi; \
        git log --format=\"%s\" -n 1 $commit_hash; \
    }; f"
[core]
    editor = vim
```
