🐸 Personal Vim8 Settings
=========================

Before installation, backup and clean all files and directories starting with '.vim' in the HOME directory to avoid effects related to the old and new configurations.

Recommended OS is CentOS 8 which have Clang 11+, GCC 7+/8+, and you also could install universal ctags(https://github.com/universal-ctags/ctags) by your self for more ctag features.

Install:

Run the command to install and config your vim shit ~

```sh
sudo wget -O - https://raw.githubusercontent.com/mrmgxxxx/vim/master/install.sh | sh
```

Keybindings:

## Custom Keybindings

| Key          | Mode   | Description                                                                                                                            | Source          |
| ------------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `<Leader>`   | -      | **Leader key**: defaults to `\` (backslash), used as prefix for custom keybindings                                                     | Vim default     |
| `<Leader>gg` | Normal | **Search word under cursor**: uses `Ag` (The Silver Searcher) to search the entire project for the word under cursor                   | fzf.vim         |
| `<Ctrl-p>`   | Normal | **Fuzzy file finder**: opens fzf fuzzy search window to quickly locate and open files in the project                                   | fzf.vim         |
| `<Leader>r`  | Normal | **Temporary relative line numbers**: enables relative line numbers for 1 second then auto-disables, useful for quick jump calculations | Custom function |

## Plugin Behaviors & Implicit Keybindings

### vim-gutentags (Auto Tag Management)

| Behavior                  | Description                                                                                                                |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Auto generate/update tags | Automatically generates tag files using `ctags` when `.root` or `.git` project root is detected, cached in `~/.cache/tags` |
| `Ctrl-]`                  | (Vim built-in) Jump to the definition of the symbol under cursor (depends on ctags)                                        |
| `Ctrl-o`                  | (Vim built-in) Jump to previous location (general purpose jump back)                                                       |
| `Ctrl-t`                  | (Vim built-in) Jump back from definition to previous location                                                              |

### vim-simple-complete (Lightweight Completion)

| Behavior           | Description                                                   |
| ------------------ | ------------------------------------------------------------- |
| Keyword completion | Provides simple, dependency-free keyword-based autocompletion |

### vim-go (Go Development)

| Behavior                     | Description                                                                                               |
| ---------------------------- | --------------------------------------------------------------------------------------------------------- |
| Enhanced syntax highlighting | Highlights types, fields, functions, function calls, operators, extra types, methods, and generate tags   |
| `Ctrl-]`                     | (Vim built-in) Jump to the definition of the symbol under cursor (`:GoDef`, gopls-based, no ctags needed) |
| `Ctrl-o`                     | (Vim built-in) Jump back through the jumplist; also works after a `:GoDef` jump                           |
| `Ctrl-t`                     | (Vim built-in) Jump back from a definition to the previous location (`:GoDefPop`)                         |

### vim-clang-format (C/C++ Formatting)

| Behavior            | Description                                                                             |
| ------------------- | --------------------------------------------------------------------------------------- |
| Auto format on save | Automatically runs `clang-format` on save for `.c/.h/.cpp/.hpp/.cc/.hh` files           |
| Style               | Detects and uses a project-local `.clang-format` style file (`detect_style_file`)       |

### vim-better-whitespace (Whitespace Management)

| Behavior           | Description                                    |
| ------------------ | ---------------------------------------------- |
| Auto highlight     | Highlights trailing whitespace at end of lines |

## Basic Editor Settings

| Setting                              | Effect                                                                        |
| ------------------------------------ | ----------------------------------------------------------------------------- |
| `set nu`                             | Show absolute line numbers                                                    |
| `set hlsearch`                       | Highlight search results                                                      |
| `set ts=4` / `set shiftwidth=4`      | Tab width 4, indent width 4                                                   |
| `set expandtab`                      | Convert tabs to spaces                                                        |
| `set autoindent`                     | Auto indent new lines based on the previous line                              |
| `set showmatch`                      | Briefly highlight matching bracket when typing                                |
| `set backspace=2`                    | Allow backspace over indent, line breaks, and pre-existing characters         |
| `set maxmempattern=10240`            | Raise pattern-match memory limit (KB) to avoid errors on large files          |
| Status line                          | Shows: working directory + file path + modified flag + line/column/percentage |

Recommended .gitconfig:

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
