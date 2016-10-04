function DelTrailSpace()
    let line = line( '.' )
    let col = col( '.' ) 

    exe '%s/\s\+$//e'

    call cursor( line, col )
endfunction
