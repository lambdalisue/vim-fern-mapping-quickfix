function! fern#mapping#quickfix#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-quickfix:new) :<C-u>call <SID>call('quickfix', ' ')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-quickfix:add) :<C-u>call <SID>call('quickfix', 'a')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-quickfix:replace) :<C-u>call <SID>call('quickfix', 'r')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-loclist:new) :<C-u>call <SID>call('loclist', ' ')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-loclist:add) :<C-u>call <SID>call('loclist', 'a')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-loclist:replace) :<C-u>call <SID>call('loclist', 'r')<CR>

  nmap <buffer> <Plug>(fern-action-quickfix) <Plug>(fern-action-quickfix:new)
  nmap <buffer> <Plug>(fern-action-loclist) <Plug>(fern-action-loclist:new)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_quickfix(helper, action) abort
  let root = a:helper.sync.get_root_node()
  let nodes = a:helper.sync.get_selected_nodes()
  let items = map(copy(nodes), { -> s:node_to_item(v:val) })
  call setqflist([], a:action, {
        \ 'items': items,
        \ 'title': root.bufname,
        \})
endfunction

function! s:map_loclist(helper, ...) abort
  let root = a:helper.sync.get_root_node()
  let nodes = a:helper.sync.get_selected_nodes()
  let items = map(copy(nodes), { -> s:node_to_item(v:val) })
  call setloclist(0, [], a:action, {
        \ 'items': items,
        \ 'title': root.bufname,
        \})
endfunction

function! s:node_to_item(node) abort
  let suffix = a:node.status isnot# g:fern#STATUS_NONE ? '/' : ''
  let module = join(a:node.__key, '/') . suffix
  return {
        \ 'filename': a:node.bufname,
        \ 'module': module,
        \}
endfunction
