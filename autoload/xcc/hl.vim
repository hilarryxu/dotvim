function xcc#hl#clear_confirm()
  match none
endfunction

function xcc#hl#clear_target()
  2match none
endfunction

function xcc#hl#confirm_line(linenr)
  " clear previous highlight result
  match none

  " highlight the line pattern
  let pat = '/\%' . a:linenr . 'l.*/'
  silent execute 'match xccConfirmLine ' . pat
endfunction

function xcc#hl#target_line(linenr)
  " clear previous highlight result
  2match none

  " highlight the line pattern
  let pat = '/\%' . a:linenr . 'l.*/'
  silent execute '2match xccTargetLine ' . pat
endfunction
