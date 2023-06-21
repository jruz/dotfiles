vim.g.wordcount_toggle = 0

vim.cmd([[
  function! WordCount()
      return wordcount().words
  endfunction
]])

vim.cmd([[
  function! ShowWordCount()
      let g:wordcount_toggle = 1
      let g:airline_section_c = '%{WordCount()} words'
      call airline#load_theme()
  endfunction
]])

vim.cmd([[
  function! HideWordCount()
      let g:wordcount_toggle = 0
      let g:airline_section_c = ''
      call airline#load_theme()
  endfunction
]])

vim.cmd([[command! WordCount if g:wordcount_toggle | call HideWordCount() | else | call ShowWordCount() | endif]])
