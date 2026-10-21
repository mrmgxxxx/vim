🐸 Personal Vim8 Settings
=========================

Before installation, backup and clean all files and directories starting with '.vim' in the HOME directory to avoid effects related to the old and new configurations.

Recommended OS is CentOS 8 which have Clang 11+, GCC 7+/8+, and you also could install universal ctags(https://github.com/universal-ctags/ctags) by your self for more ctag features.

Run the command to install and config your vim shit ~

```sh
curl -fsSL https://raw.githubusercontent.com/mrmgxxxx/vim/master/install.sh | sudo bash
```

### Custom Keybindings

| Key          | Mode   | Description                                                                                                                            | Source          |
| ------------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `<Leader>`   | -      | **Leader key**: defaults to `\` (backslash), used as prefix for custom keybindings                                                     | Vim default     |
| `<Leader>gg` | Normal | **Search word under cursor**: uses `Ag` (The Silver Searcher) to search the word under cursor across the whole project root (`.root`/`.git`), with a preview window | fzf.vim         |
| `<Ctrl-p>`   | Normal | **Fuzzy file finder**: opens fzf to fuzzy-find files across the whole project root (`.root`/`.git`), with a preview window             | fzf.vim         |
| `<Leader>r`  | Normal | **Temporary relative line numbers**: enables relative line numbers for 1 second then auto-disables, useful for quick jump calculations | Custom function |
| `<Leader>f`  | Normal | **Blame current line**: echoes the last commit (hash / summary / author / mail / time) that touched the line under cursor                | Custom function |

### vim-gutentags (Auto Tag Management)

| Behavior                  | Description                                                                                                                |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Auto generate/update tags | Automatically generates tag files using `ctags` when `.root` or `.git` project root is detected, cached in `~/.cache/tags` |
| `Ctrl-]`                  | (Vim built-in) Jump to the definition of the symbol under cursor (depends on ctags)                                        |
| `Ctrl-o`                  | (Vim built-in) Jump to previous location (general purpose jump back)                                                       |
| `Ctrl-t`                  | (Vim built-in) Jump back from definition to previous location                                                              |

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

### git blame (Line Commit Info)

| Behavior          | Description                                                                                                   |
| ----------------- | ------------------------------------------------------------------------------------------------------------- |
| Blame current line| Runs `git blame --porcelain` on the line under cursor and echoes the commit that last changed it              |
| Output format     | `[hash] summary author-mail author (YYYY-MM-DD HH:MM:SS)`, shown on the command line                          |
| Not a git repo    | Echoes the git error (e.g. `git blame failed`) instead of raising an error                                    |
| Not committed yet | Echoes `[Not committed yet]` for lines that are modified but not committed                                    |
| Implementation    | Self-contained function in `vimrc` (no plugin), replacing `zivyangll/git-blame.vim`; triggered by `<Leader>f` |

### Simple Auto Completion

| Behavior           | Description                                                                                  |
| ------------------ | -------------------------------------------------------------------------------------------- |
| Keyword completion | Auto triggers keyword completion after typing 3 keyword characters                           |
| Popup behavior     | `completeopt=menuone,noselect` shows the menu without preselecting; menu height capped at 10 |

### Whitespace Management

| Behavior            | Description                                                             |
| ------------------- | ----------------------------------------------------------------------- |
| Auto highlight      | Highlights trailing whitespace at end of lines (red background)         |
| Auto strip on save  | Removes trailing whitespace on save while preserving cursor/view state  |

### Basic Editor Settings

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
