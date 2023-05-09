🐸 Personal Vim8 Configs
=====================

Before installation, backup and clean all files and directories starting with '.vim' in the HOME directory to avoid effects related to the old and new configurations.

Recommended OS is CentOS 8 which have Clang 11+, GCC 7+/8+, and you also could install universal ctags(https://github.com/universal-ctags/ctags) by your self for more ctag features.

**👀 Install:**

Run the command to install and config your vim shit ~

```sh
sudo wget -O - https://raw.githubusercontent.com/mrmgxxxx/vim/master/install.sh | sh
```

**🌈 Others:**

![avatar](https://cloud.githubusercontent.com/assets/10374559/23341312/1961f416-fc45-11e6-83ba-d7180c5fdd6d.png)

🍔 Recommended Theme: https://github.com/altercation/vim-colors-solarized

```sh
let g:solarized_termcolors=256
let g:solarized_termcolors=16
let g:solarized_termtrans=1
```

🍺 Recommended Color:

```sh
Foreground: 00f900
Background: 002b36
```

🍟 Recommended Terminal:

```sh
export PS1='\[\e[32;1m\][\u@\h \W]\\$> \[\e[0m\]'
```
