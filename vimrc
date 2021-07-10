""""插件列表""""
call plug#begin('~/.vim/plugged')
" 目录树
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" 目录树导航优化
Plug 'jistr/vim-nerdtree-tabs'
" 目录树导航GIT信息
Plug 'Xuyuanp/nerdtree-git-plugin'
" 文件查找
Plug 'kien/ctrlp.vim'
" 自动生成ctags
Plug 'ludovicchabant/vim-gutentags'
" 多语言语法纠错
Plug 'vim-syntastic/syntastic'
" CPP语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'
" 轻量级自动补全
Plug 'skywind3000/vim-auto-popmenu'
" 代码结构展示
Plug 'preservim/tagbar'
" GOLANG插件
Plug 'fatih/vim-go'
Plug 'volgar1x/vim-gocode'
" Vim状态栏插件，包括显示行号，列号，文件类型，文件名，以及Git状态
Plug 'vim-airline/vim-airline'
" Markdown插件
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
" 代码GIT提交信息插件
Plug 'zivyangll/git-blame.vim'
" JSON插件
Plug 'elzr/vim-json'
" 显示多余空格
Plug 'ntpeters/vim-better-whitespace'
" 自动对齐
Plug 'godlygeek/tabular'
call plug#end()

" 插件: scrooloose/nerdtree
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

let NERDTreeShowLineNumbers=1

" 打开文件时是否显示目录
let NERDTreeAutoCenter=1

" 是否显示隐藏文件
let NERDTreeShowHidden=0

" 设置宽度
let NERDTreeWinSize=31

" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']

" 打开 vim 文件及显示书签列表
let NERDTreeShowBookmarks=2

" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1

" 插件: scrooloose/nerdtree
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeShowIgnoredStatus = 1

" 插件: ludovicchabant/vim-gutentags
let g:gutentags_enabled = 1
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project', '.vimex', '.vim']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的tags文件放入~/.cache/tags，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 检测~/.cache/tags
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置ctags的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 插件: octol/vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" 插件: skywind3000/vim-auto-popmenu
" 设定需要生效的文件类型，如果是 "*" 的话，代表所有类型
let g:apc_enable_ft = {'*':1}
set cpt=.,k,w,b
set completeopt=menu,menuone,noselect
set shortmess+=c

" 插件: fatih/vim-go
imap <F5> <C-x><C-o>
au filetype go inoremap <buffer> . .<C-x><C-o>
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_chan_whitespace_error = 0
let g:go_highlight_methods = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1

" 插件: vim-syntastic/syntastic
let g:syntastic_check_on_wq=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='►'
let g:syntastic_enable_highlighting=1
let g:syntastic_go_checkers = ['go']
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler = 'gcc'
let g:syntastic_cpp_compiler_options = '-std=c++11'

" 插件: zivyangll/git-blame.vim
nnoremap <Leader>f :<C-u>call gitblame#echo()<CR>

" 插件: preservim/tagbar
nmap <F4> :TagbarToggle<CR>

" 终端编码设置
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set helplang=cn

" 基础设置
set nu              " 显示行号
set hlsearch        " 高亮搜索
set backspace=2     " 启用delete按键
set ts=4            " tab替换空格宽度
set expandtab
set shiftwidth=4
set autoindent      " 自动indent
set showmatch       " 显示括号等匹配
set colorcolumn=120 " 设置中线宽度

" 其他设置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 记录上一次浏览位置
