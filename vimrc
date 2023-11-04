" plugins
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'ludovicchabant/vim-gutentags'

Plug 'dense-analysis/ale'

Plug 'fatih/vim-go'

Plug 'rhysd/vim-clang-format'

Plug 'maxboisvert/vim-simple-complete'

Plug 'zivyangll/git-blame.vim'

Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'ntpeters/vim-better-whitespace'

Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'altercation/vim-colors-solarized'

call plug#end()

" junegunn/fzf.vim
nnoremap <silent> <Leader>gg :Ag <C-R><C-W><CR>
nnoremap <silent> <c-p> :Files <CR>

" ludovicchabant/vim-gutentags
let g:gutentags_enabled = 1
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.root', '.git']
let g:gutentags_ctags_tagfile = 'gutentags'
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" ctags/gtags
" universal ctags(https://github.com/universal-ctags/ctags)
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" dense-analysis/ale
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_cpp_gcc_options = ' -std=c++11 '
let g:ale_cpp_clang_options = ' -std=c++11 '
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \   'csh': ['shell'],
  \   'zsh': ['shell'],
  \   'python': ['pylint'],
  \   'go': ['gofmt', 'golint'],
  \   'c': ['clang', 'gcc'],
  \   'cpp': ['clang', 'g++'],
  \ }

" fatih/vim-go
let g:go_fmt_command = "gofmt"
"let g:go_fmt_command = "goimports"
let g:go_version_warning = 0
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

" rhysd/vim-clang-format
let g:clang_format#command = 'clang-format'
autocmd FileType c ClangFormatAutoEnable
autocmd FileType h ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable
autocmd FileType hpp ClangFormatAutoEnable
autocmd FileType cc ClangFormatAutoEnable
autocmd FileType hh ClangFormatAutoEnable
autocmd FileType cxx ClangFormatAutoEnable
autocmd FileType hxx ClangFormatAutoEnable

" detects the style file like .clang-format
let g:clang_format#detect_style_file=1
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
        \     "SpacesInAngles" : "false",
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

" "AlignConsecutiveAssignments" : "true"
" "AlignConsecutiveDeclarations" : "true"

" zivyangll/git-blame.vim
nnoremap <Leader>f :<C-u>call gitblame#echo()<CR>

" octol/vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
" template configs are very low performance
"let g:cpp_experimental_simple_template_highlight = 1
"let g:cpp_experimental_template_highlight = 1

" vim-scripts/DoxygenToolkit.vim
let g:DoxygenToolkit_briefTag_funcName = "yes"
let g:DoxygenToolkit_briefTag_pre = "@brief "
let g:DoxygenToolkit_paramTag_pre = "@param "
let g:DoxygenToolkit_returnTag = "@return "
let g:DoxygenToolkit_throwTag_pre = "@throw "
let g:DoxygenToolkit_fileTag = "@file "
let g:DoxygenToolkit_versionTag = "@version "
let g:DoxygenToolkit_blockTag = "@name "
let g:DoxygenToolkit_classTag = "@class "
let g:doxygen_enhanced_color = 1

" internal plugin and hot keys
" vim internal netrw plugin key
nnoremap <F3> :Vexplore<CR>
let g:netrw_winsize = 30

" basic settings
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
set hlsearch
set backspace=2
set ts=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent
set showmatch
set colorcolumn=150
set cursorline
set cursorcolumn
set complete-=t
set complete-=i
set shortmess+=c
set statusline=%F\ %m\ %=Ln\ %l,\ Col\ %c\ %p%%
set laststatus=2

syntax enable
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized
