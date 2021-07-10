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
" 语法纠错
Plug 'dense-analysis/ale'
" CPP语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'
" 自动补全
Plug 'ycm-core/YouCompleteMe'
" GOLANG插件
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Vim状态栏插件，包括显示行号，列号，文件类型，文件名，以及Git状态
Plug 'vim-airline/vim-airline'
" Markdown插件
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
" 代码GIT提交信息插件
Plug 'zivyangll/git-blame.vim'
call plug#end()

""""NERDTREE目录树插件""""
" 打开和关闭NERDTree快捷键
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
" 显示行号
let NERDTreeShowLineNumbers=1
" 打开文件时是否显示目录
let NERDTreeAutoCenter=1
" 是否显示隐藏文件
let NERDTreeShowHidden=0
" 设置宽度
" let NERDTreeWinSize=31
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 打开 vim 文件及显示书签列表
let NERDTreeShowBookmarks=2
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1

""""NERDTREE GIT信息插件""""
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


""""gutentags插件相关设置""""
" 启用
let g:gutentags_enabled = 1

" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project', '.vimex']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']


""""ale插件相关设置""""
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''
let g:ale_sign_error = "\ue009\ue009"
let g:ale_fix_on_save = 1
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta


""""CPP语法高亮
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1


""""自动补全""""
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
" 触发语义补全快捷键
let g:ycm_key_invoke_completion = '<c-z>'

" 自动弹出函数原型预览窗口，它搞乱我的布局，我有其他方法查看函数的原型，如果你和我一样想关闭该功能的话，增加两行配置
set completeopt=menu,menuone

noremap <c-z> <NOP>

" 语义触发的条件
" 定义了 g:ycm_semantic_triggers 以后，默认的 . / -> / :: 是不会被覆盖的，只会追加成新的 trigger，
" 这里我们追加了一个正则表达式，代表相关语言的源文件中，用户只需要输入符号的两个字母，即可自动弹出语义补全
let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }

" 自动补全框背景色设置
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

""""GOLANG插件""""
"格式化将默认的 gofmt 替换
"let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_version_warning = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_methods = 1
let g:go_highlight_generate_tags = 1
let g:godef_split=2

""""GITBlame提交信息插件""""
nnoremap <Leader>f :<C-u>call gitblame#echo()<CR>


""""终端编码设置""""
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set helplang=cn


""""基础设置""""
set nu
set ts=4
set shiftwidth=4
set backspace=2
set expandtab
set autoindent
set showmatch
set colorcolumn=120
