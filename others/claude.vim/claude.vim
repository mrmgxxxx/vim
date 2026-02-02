" File: plugin/claude.vim
" vim: sw=2 ts=2 et
" Claude terminal window toggle plugin for Vim

" Configuration
if !exists('g:claude_map_toggle')
  let g:claude_map_toggle = '<leader>tt'
endif

if !exists('g:claude_map_close')
  " Map to close Claude terminal from within terminal window
  let g:claude_map_close = '<leader>tq'
endif

if !exists('g:claude_terminal_cmd')
  " Default: use $SHELL or bash
  let g:claude_terminal_cmd = exists('$SHELL') ? $SHELL : 'bash'
endif

if !exists('g:claude_auto_cmd')
  " Command to run automatically after opening Claude terminal
  let g:claude_auto_cmd = 'claude'
endif

if !exists('g:claude_position')
  " Options: 'bottom', 'right', 'top', 'left'
  let g:claude_position = 'right'
endif

if !exists('g:claude_size')
  " Size in lines (for bottom/top) or columns (for left/right)
  let g:claude_size = &columns / 2
endif

" Setup keybinding
function! s:SetupClaudeKeybindings()
  command! ClaudeToggle call s:ToggleClaude()
  execute "nnoremap " . g:claude_map_toggle . " :ClaudeToggle<CR>"
endfunction

augroup ClaudeToggle
  autocmd!
  autocmd VimEnter * call s:SetupClaudeKeybindings()
  " Clean up Claude terminal buffer when quitting Vim
  autocmd QuitPre * call s:CleanupClaude()
augroup END

" Toggle Claude terminal window
function! s:ToggleClaude()
  " Check if Claude terminal buffer already exists
  let l:term_bufnr = -1
  for bufnr in range(1, bufnr('$'))
    if bufexists(bufnr) && getbufvar(bufnr, '&buftype') == 'terminal'
      if getbufvar(bufnr, 'claude_terminal') == 1
        let l:term_bufnr = bufnr
        break
      endif
    endif
  endfor

  " If Claude terminal buffer exists and is visible, hide it
  if l:term_bufnr != -1
    let l:term_winid = bufwinid(l:term_bufnr)
    if l:term_winid != -1
      " Claude terminal is visible, close the window (force close to avoid job warning)
      call win_gotoid(l:term_winid)
      close!
      return
    endif
  endif

  " Open or show Claude terminal
  if l:term_bufnr != -1
    " Claude terminal exists but not visible, show it
    call s:OpenClaudeWindow()
    execute 'buffer' l:term_bufnr
    call s:SetupClaudeMappings()
  else
    " Create new Claude terminal
    if g:claude_position == 'bottom'
      execute 'botright terminal ++rows=' . g:claude_size . ' ' . g:claude_terminal_cmd
    elseif g:claude_position == 'top'
      execute 'topleft terminal ++rows=' . g:claude_size . ' ' . g:claude_terminal_cmd
    elseif g:claude_position == 'right'
      execute 'botright vertical terminal ++cols=' . g:claude_size . ' ' . g:claude_terminal_cmd
    elseif g:claude_position == 'left'
      execute 'topleft vertical terminal ++cols=' . g:claude_size . ' ' . g:claude_terminal_cmd
    else
      execute 'botright terminal ++rows=' . g:claude_size . ' ' . g:claude_terminal_cmd
    endif
    let b:claude_terminal = 1
    file Claude
    " Disable swap file for Claude terminal buffer
    setlocal noswapfile
    " Set up close mapping for Claude terminal window
    call s:SetupClaudeMappings()
    " Send auto command if configured
    if !empty(g:claude_auto_cmd)
      call term_sendkeys(bufnr('%'), g:claude_auto_cmd . "\<CR>")
    endif
  endif
endfunction

" Open Claude terminal window at configured position (for reopening)
function! s:OpenClaudeWindow()
  if g:claude_position == 'bottom'
    execute 'botright ' . g:claude_size . 'new'
  elseif g:claude_position == 'top'
    execute 'topleft ' . g:claude_size . 'new'
  elseif g:claude_position == 'right'
    execute 'botright ' . g:claude_size . 'vnew'
  elseif g:claude_position == 'left'
    execute 'topleft ' . g:claude_size . 'vnew'
  else
    execute 'botright ' . g:claude_size . 'new'
  endif
endfunction

" Setup mappings inside Claude terminal window
function! s:SetupClaudeMappings()
  " Vim: map in terminal mode
  execute "tnoremap <buffer> " . g:claude_map_close . " <C-W>:close!<CR>"
  execute "tnoremap <buffer> " . g:claude_map_toggle . " <C-W>:close!<CR>"
endfunction

" Cleanup Claude terminal when quitting Vim
function! s:CleanupClaude()
  " Find Claude terminal buffer
  for bufnr in range(1, bufnr('$'))
    if bufexists(bufnr) && getbufvar(bufnr, '&buftype') == 'terminal'
      if getbufvar(bufnr, 'claude_terminal') == 1
        " Force delete the Claude terminal buffer
        execute 'bwipeout! ' . bufnr
        break
      endif
    endif
  endfor
endfunction
