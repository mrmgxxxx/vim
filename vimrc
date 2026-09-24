" plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'maxboisvert/vim-simple-complete'
Plug 'fatih/vim-go'
Plug 'ludovicchabant/vim-gutentags'
Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

" junegunn/fzf.vim
nnoremap <silent> <Leader>gg :Ag <C-R><C-W><CR>
nnoremap <silent> <c-p> :Files <CR>

" fatih/vim-go
let g:go_version_warning = 0
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_methods = 1
let g:go_highlight_generate_tags = 1

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
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--c++-kinds=+pxI', '--c-kinds=+px']

" rhysd/vim-clang-format
let g:clang_format#detect_style_file=1
autocmd FileType c ClangFormatAutoEnable
autocmd FileType h ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable
autocmd FileType hpp ClangFormatAutoEnable
autocmd FileType cc ClangFormatAutoEnable
autocmd FileType hh ClangFormatAutoEnable

" octol/vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" show relative line number
function! ToggleRelativeNumberTemporary()
  echo "enabling relative line number"
  set rnu
  call timer_start(1000, 'DisableRelativeNumber')
endfunction
function! DisableRelativeNumber(timer_id)
  echo "disabling relative line number"
  set nornu
endfunction
command! ToggleRelativeNumberTemporary call ToggleRelativeNumberTemporary()
nnoremap <leader>r :ToggleRelativeNumberTemporary<CR>

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
set showmatch
set complete-=t
set complete-=i
set shortmess+=c
set laststatus=2
set statusline=%{getcwd()}\ %F\ %m\ %=Ln\ %l,\ Col\ %c\ %p%%
set maxmempattern=10240
