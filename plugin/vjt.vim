if exists('g:loaded_vjt') | finish | endif "prevent loading twice

let s:save_cpo = &cpo "save use coptions
set cpo&vim "reset them to default

" command to run our plugin
command! Vjt lua require'vjt'.vjt()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_vjt = 1
