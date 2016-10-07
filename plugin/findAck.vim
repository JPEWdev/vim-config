if(!exists("g:FIND_ACK_ARGS"))
    let g:FIND_ACK_ARGS = ["-k"]
endif


function! findAck#FindAck(cmd, args, ...)
    let l:found_pattern = 0
    let g:FIND_ACK_ARGS = []

    for a in a:000
        if a[0] != '-'
            if l:found_pattern
                let g:FIND_ACK_ARGS = g:FIND_ACK_ARGS + [a]
            else
                let l:found_pattern = 1
            endif
        else
            let g:FIND_ACK_ARGS = g:FIND_ACK_ARGS + [a]
        endif
    endfor

    call ack#Ack(a:cmd, a:args)
endfunction

command! -bang -nargs=* -complete=file FindAck call findAck#FindAck('grep<bang>', <q-args>, <f-args>)

function! GetFindAck(command, cword)
    return ":" . a:command . " " . a:cword . " " . join(map(copy(g:FIND_ACK_ARGS), "escape(v:val, ' \')"))
endfunction

