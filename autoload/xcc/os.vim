function xcc#os#is(name)
  if a:name ==# 'osx'
    return has('macunix')
  elseif a:name ==# 'windows'
    return  (has('win16') || has('win32') || has('win64'))
  elseif a:name ==# 'linux'
    return has('unix') && !has('macunix') && !has('win32unix')
  else
    call xcc#msg#warn('Invalid name ' . a:name . ", Please use 'osx', 'windows' or 'linux'")
  endif

  return 0
endfunction
