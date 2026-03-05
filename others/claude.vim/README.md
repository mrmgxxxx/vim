# Claude Terminal Plugin Configuration Guide

## Plugin Introduction

Claude.vim is a minimalist Vim terminal window toggle plugin that provides one-key open/close functionality for claude terminal windows.

### Key Features

- 🚀 One-key open/close claude terminal window
- 📍 Configurable claude terminal position (top/bottom/left/right)
- 📏 Configurable claude terminal size
- 🔄 Session persistence - terminal won't be lost when closing the window
- ⚡ Automatically uses current shell ($SHELL)
- 🎯 Supports Vim 8.1+
- 🤖 Supports auto-executing commands after opening terminal

## Configuration Options

All configuration options are optional - the plugin provides reasonable defaults. Add configurations in `~/.vimrc`

### 1. g:claude_map_toggle

**Purpose**: Keyboard mapping for opening/closing the claude terminal

**Default**: `'<leader>tt'` (usually `\tt`)

**Examples**:
```vim
" Use <leader>tt (default)
let g:claude_map_toggle = '<leader>tt'

" Change to Ctrl+t
let g:claude_map_toggle = '<C-t>'

" Change to F12
let g:claude_map_toggle = '<F12>'
```

### 2. g:claude_map_close

**Purpose**: Keyboard mapping for closing the claude terminal from within the terminal window

**Default**: `'<leader>tq'` (usually `\tq`)

**Note**: This shortcut only works inside the terminal window, useful for quickly closing the terminal without exiting the shell first

**Examples**:
```vim
" Use <leader>tq (default)
let g:claude_map_close = '<leader>tq'

" Change to Ctrl+q
let g:claude_map_close = '<C-q>'
```

### 3. g:claude_terminal_cmd

**Purpose**: Specify the shell command to run when the terminal starts

**Default**: Value of `$SHELL` environment variable, or `'bash'` if not set

**Examples**:
```vim
" Use default shell (recommended)
" Don't set this option, will automatically use $SHELL

" Force use bash
let g:claude_terminal_cmd = 'bash'

" Use zsh
let g:claude_terminal_cmd = 'zsh'

" Use fish
let g:claude_terminal_cmd = 'fish'
```

### 4. g:claude_auto_cmd

**Purpose**: Command to automatically execute after terminal opens

**Default**: `'claude'`

**Note**: The plugin will automatically send this command (with enter) after terminal creation, suitable for auto-starting a program or script

**Examples**:
```vim
" Auto-run claude command (default)
let g:claude_auto_cmd = 'claude'

" Auto-run claude command in personalized way
let g:claude_auto_cmd = '~/.local/bin/claude --xxxx'
```

### 5. g:claude_position

**Purpose**: Set the position of the claude terminal window

**Default**: `'right'`

**Valid Values**:
- `'bottom'` - Bottom
- `'top'` - Top
- `'right'` - Right side
- `'left'` - Left side

**Examples**:
```vim
" Show on right side (default)
let g:claude_position = 'right'

" Show at bottom
let g:claude_position = 'bottom'

" Show on left side
let g:claude_position = 'left'

" Show at top
let g:claude_position = 'top'
```

### 6. g:claude_size

**Purpose**: Set the size of the claude terminal window

**Default**: `&columns / 2` (half of screen width)

**Note**:
- When position is `'bottom'` or `'top'`, this value represents **number of rows**
- When position is `'right'` or `'left'`, this value represents **number of columns**

**Examples**:
```vim
" Use half of screen width (default)
let g:claude_size = &columns / 2

" Bottom terminal with 15 rows
let g:claude_position = 'bottom'
let g:claude_size = 15

" Right side terminal with 80 columns
let g:claude_position = 'right'
let g:claude_size = 80

" Large bottom terminal with 25 rows
let g:claude_position = 'bottom'
let g:claude_size = 25
```
