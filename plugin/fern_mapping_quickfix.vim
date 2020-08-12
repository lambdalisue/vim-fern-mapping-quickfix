if exists('g:fern_mapping_quickfix_loaded')
  finish
endif
let g:fern_mapping_quickfix_loaded = 1

call add(g:fern#mapping#mappings, 'quickfix')
