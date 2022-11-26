""""插件列表""""
call plug#begin('~/.vim/plugged')
" 目录树
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" 关键字搜索和文件查找
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 自动生成ctags
Plug 'ludovicchabant/vim-gutentags'

" 多语言语法纠错
Plug 'vim-syntastic/syntastic'

" CPP语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'

" 代码格式化
Plug 'rhysd/vim-clang-format'

" GOLANG插件
Plug 'fatih/vim-go'

" 状态栏插件
Plug 'vim-airline/vim-airline'

" 简单自动补全
Plug 'maxboisvert/vim-simple-complete'

" 代码GIT提交信息插件
Plug 'zivyangll/git-blame.vim'

" 显示多余空格
Plug 'ntpeters/vim-better-whitespace'

" Doxygen注释
Plug 'vim-scripts/DoxygenToolkit.vim'

" 主题配色: solarized
Plug 'altercation/vim-colors-solarized'

" 主题配色: codedark
Plug 'tomasiser/vim-code-dark'
call plug#end()

" 插件: scrooloose/nerdtree
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

" 显示行号信息
let NERDTreeShowLineNumbers=1
" 打开文件时是否显示目录
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=0
" 设置宽度
let NERDTreeWinSize=31
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']

" 插件: junegunn/fzf.vim
" 搜索当前单词
nnoremap <silent> <Leader>gg :Ag <C-R><C-W><CR>
" 搜索文件
nnoremap <silent> <c-p> :Files <CR>

" 插件: ludovicchabant/vim-gutentags
let g:gutentags_enabled = 1

" 关闭默认加入工程文件列表，完全按照下面自行定义的列表进行工程根目录搜索
let g:gutentags_add_default_project_roots = 0

" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
" 注意混合项目时（多个含有工程文件的文件夹通知存在），在上层目录操作可能无法实现跳转,
" 很多时候项目中都含有.git，这种情况下需要注意下项目根目录位置, 根据需要灵活修改这里的配置
" 我的做法是在常规模式下不会加入.git等配置，只会保留.root的匹配，自行控制项目根目录
" 举个例子：目录下有两个子目录，这两个子目录都是单独的仓库有各自的.git文件，这种情况下每个目录下
" 会使用各自目录下的tags文件，这是两者之间可能无法互相跳转，需要让他们都是用上层根目录的tags来保证
" 两者可以相互关联跳转定义
" 遇到无法正确跳转匹配时，可以再vim命令行输入'echo tagfiles()'来查看当前使用的tags文件进行问题的debug
let g:gutentags_project_root = ['.root']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = 'gutentags'
" 将自动生成的tags文件放入~/.cache/tags，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 检测~/.cache/tags
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 开启ctags/gtags支持
let g:gutentags_modules = []
if executable('ctags')
    " 如果想要能够支持更高的C++11以上语法特性, 则需要安装universal ctags(https://github.com/universal-ctags/ctag)
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
endif
" 配置ctags的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 插件: vim-syntastic/syntastic
let g:syntastic_check_on_wq=1
let g:syntastic_cpp_check_header = 1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='►'
let g:syntastic_enable_highlighting=1
let g:syntastic_go_checkers = ['go']
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler = 'gcc'
let g:syntastic_cpp_compiler_options = '-std=c++11'
"let g:syntastic_c_include_dirs = ['']

" 插件: octol/vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" 插件: rhysd/vim-clang-format
let g:clang_format#command = 'clang-format'
autocmd FileType c ClangFormatAutoEnable
autocmd FileType h ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable
autocmd FileType hpp ClangFormatAutoEnable
autocmd FileType cc ClangFormatAutoEnable
autocmd FileType hh ClangFormatAutoEnable
autocmd FileType cxx ClangFormatAutoEnable
autocmd FileType hxx ClangFormatAutoEnable
let g:clang_format#auto_format=1
let g:clang_format#filetype_style_options = {
        \ "proto" : {
        \     "Language" : "Proto",
        \     "DisableFormat" : "true"
        \ },
        \ "cpp" : {
        \     "Language" : "Cpp",
        \     "BasedOnStyle" : "LLVM",
        \     "UseTab" : "Never",
        \     "TabWidth" : 4,
        \     "IndentWidth" : 4,
        \     "ColumnLimit" : 0,
        \     "MaxEmptyLinesToKeep" : 1,
        \     "AccessModifierOffset" : -4,
        \     "IndentCaseLabels" : "false",
        \     "FixNamespaceComments" : "true",
        \     "DerivePointerAlignment" : "true",
        \     "PointerAlignment" : "Left",
        \     "BreakBeforeBraces" : "Custom",
        \     "SpacesInAngles":"false",
        \     "AllowShortFunctionsOnASingleLine" : "Inline",
        \     "BraceWrapping" : {
        \       "AfterCaseLabel" : "true",
        \       "AfterUnion" : "true",
        \       "AfterStruct" : "true",
        \       "AfterClass" : "true",
        \       "AfterEnum" : "true",
        \       "AfterFunction" : "true",
        \       "AfterControlStatement" : "true",
        \       "BeforeCatch" : "true",
        \       "BeforeElse" : "true",
        \       "AfterNamespace" : "false"
        \     }
        \   }
        \ }

" 备忘选项:
" "AlignConsecutiveAssignments" : "true"
" "AlignConsecutiveDeclarations" : "true"

" 插件: fatih/vim-go
" 使用YCM补全时不要开启这两项，会造成冲突
"imap <F5> <C-x><C-o>
"au filetype go inoremap <buffer> . .<C-x><C-o>
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

" 插件: zivyangll/git-blame.vim
nnoremap <Leader>f :<C-u>call gitblame#echo()<CR>

" 插件: vim-scripts/DoxygenToolkit.vim
let g:DoxygenToolkit_briefTag_funcName = "yes"
let g:doxygenToolkit_authorName="setup-your-name"
let g:DoxygenToolkit_briefTag_pre = "@brief "
let g:DoxygenToolkit_paramTag_pre = "@param "
let g:DoxygenToolkit_returnTag = "@return "
let g:DoxygenToolkit_throwTag_pre = "@throw " " @exception is also valid
let g:DoxygenToolkit_fileTag = "@file "
let g:DoxygenToolkit_dateTag = "@date "
let g:DoxygenToolkit_authorTag = "@author "
let g:DoxygenToolkit_versionTag = "@version "
let g:DoxygenToolkit_blockTag = "@name "
let g:DoxygenToolkit_classTag = "@class "
let g:doxygen_enhanced_color = 1

" Lincese
"let g:DoxygenToolkit_licenseTag = "Copyright..."

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
set smartindent     " 智能indent
set showmatch       " 显示括号等匹配
set colorcolumn=120 " 设置中线宽度
set cursorline      " 十字光标对齐线
set cursorcolumn    " 十字光标对齐线

" 其他设置
if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 记录上一次浏览位置
endif

" 主题设置(深色)
syntax enable
set background=dark
colorscheme codedark

" 可以启用其他个性化主题
let g:solarized_termtrans = 1
colorscheme solarized
