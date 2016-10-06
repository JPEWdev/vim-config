if exists('g:loaded_comments') || &cp
    finish
endif

if !exists( "g:comment_no_closing_indent" )
    let g:comment_no_closing_indent = 0
endif

if !exists("g:path_to_skeletons")
    let g:path_to_skeletons = expand('<sfile>:p:h:h') . "/skel"
endif

function InsertFileComment()
    "---------------------------------------------------------------------------
    " Save cpoptions
    "---------------------------------------------------------------------------
    let cpoptions = &cpoptions

    "---------------------------------------------------------------------------
    " Remove the 'a' option - prevents the name of the
    " alternate file being overwritten with a :read command
    "---------------------------------------------------------------------------
    exe "set cpoptions=" . substitute(cpoptions, "a", "", "g")

    let line_count = line( '$' )

    let fileext = substitute( bufname( '%' ), '.*\.\([^\.]\+\)$', '\1', '' )

    let filename = substitute( bufname( '%' ), '.*[\\/]\([^\\/]\+\)$', '\1', '' )

    let guard_name = toupper( substitute( filename, '[^a-zA-Z0-9_]', '_', 'g' ) )

    let year = strftime( "%Y" )

    exe "0r " . g:path_to_skeletons . "/" . fileext . "/file.txt"
    for i in range( 1, line( '$' ) - line_count )
        let line = getline( i )
        let replacement = substitute( line, '\[NAME\]', filename , 'g' )
        let replacement = substitute( replacement, '\[GUARD_NAME\]', guard_name, 'g' ) 
        let replacement = substitute( replacement, '\[YEAR\]', year, 'g' )
        
        let idx = match( replacement, '%c' )

        if idx != -1 
            let replacement = substitute( replacement, '%c', '', '' )
            call cursor( i, idx ) 
        endif
        
        call setline( i, replacement )
    endfor

    "---------------------------------------------------------------------------
    " Restore cpoptions
    "---------------------------------------------------------------------------
    exe "set cpoptions=" . cpoptions
endfunction

function InsertFuncComment( name )
    "---------------------------------------------------------------------------
    " Save cpoptions
    "---------------------------------------------------------------------------
    let cpoptions = &cpoptions

    "---------------------------------------------------------------------------
    " Remove the 'a' option - prevents the name of the
    " alternate file being overwritten with a :read command
    "---------------------------------------------------------------------------
    exe "set cpoptions=" . substitute(cpoptions, "a", "", "g")

    exe "normal k"

    let line_count = line( '$' )
    let start_line = line( '.' )

    let fileext = substitute( bufname( '%' ), '.*\.\([^\.]\+\)$', '\1', '' )
    
    exe "read " . g:path_to_skeletons . "/" . fileext . "/func.txt"

    for i in range( start_line, start_line + ( line( '$' ) - line_count ) )
        let line = getline( i )
        let replacement = substitute( line, '\[NAME\]', a:name , 'g' )

        let idx = match( replacement, '%c' )

        if idx != -1 
            let replacement = substitute( replacement, '%c', '', '' )
            call cursor( i, idx ) 
        endif

        call setline( i, replacement )
    endfor
    
    "---------------------------------------------------------------------------
    " Restore cpoptions
    "---------------------------------------------------------------------------
    exe "set cpoptions=" . cpoptions
endfunction

command! InsertFuncComment call InsertFuncComment(expand('<cword>'))
command! InsertFileComment call InsertFileComment()

"function UnCommentBlock( first_line, last_line, line, col )
"    "---------------------------------------------------------------------------
"    " Read Configuration Settings 
"    "---------------------------------------------------------------------------
"    let introducer = exists("b:comment_introducer") ? b:comment_introducer : "/*"
"    let trailer = exists( "b:comment_trailer" ) ? b:comment_trailer : "*/"
"    let border = exists( "b:comment_border" ) ? b:comment_border : "-"
"    let leader = exists("b:comment_leader") ? b:comment_leader : ""
"    let leader_spacing = exists( "b:comment_leader_spacing" ) ? b:comment_leader_spacing : 1
"    let width = exists( "g:comment_max_col" ) ? g:comment_max_col : 0
"    
"    "---------------------------------------------------------------------------
"    " Get Initial Cursor Position  
"    "---------------------------------------------------------------------------
"    let cur_cursor_col = a:col
"    let cur_cursor_line = a:line
"
"    let top_line_header = 0
"    let bottom_line_footer = 0
"    let first_line = a:first_line
"    let last_line = a:last_line
"
"    "---------------------------------------------------------------------------
"    " Set up Regular Expressions for Matches
"    "---------------------------------------------------------------------------
"    let escape_chars = '*.\'
"    
"    let header_regex = '^[\t ]*' . escape( introducer, escape_chars ) . '\(' . escape( border, escape_chars ) . '\)\+' . '[\t ]*$'
"    let footer_regex = '^[\t ]*'
"    if strlen( leader ) > 0
"        let footer_regex = footer_regex . '\(' . escape( leader, escape_chars ) . '\)\='
"    endif
"    let footer_regex = footer_regex . '\(' . escape( border, escape_chars ) . '\)\+' . escape( trailer, escape_chars ) . '[\t ]*$'
"    let line_regex = '^[\t ]*' . escape( leader, escape_chars )
"   
"    "---------------------------------------------------------------------------
"    " Make sure all visually selected lines are in a comment  
"    "---------------------------------------------------------------------------
"    for linenum in range( a:first_line, a:last_line )
"        let cur_line = getline( first_line )
"        
"        if cur_line !~ line_regex
"            if a:first_line != a:last_line && ( ( linenum == a:first_line && cur_line =~ header_regex ) || ( linenum == a:last_line && cur_line =~ footer_regex) ) 
"                continue
"            endif
"
"            echo "Invalid Comment Block"
"            return 0
"        endif
"    endfor
"
"    "---------------------------------------------------------------------------
"    " Find the header of the comment
"    "---------------------------------------------------------------------------
"    while first_line > 0
"        let cur_line = getline( first_line )
"
"        "-----------------------------------------------------------------------
"        " Check if this line matches the header regex
"        "-----------------------------------------------------------------------
"        if cur_line =~ header_regex
"            break
"        endif
"
"        "-----------------------------------------------------------------------
"        " If this line doesn match the intermediate line, we are outside of
"        " the comment
"        "-----------------------------------------------------------------------
"        if cur_line !~ line_regex
"            echo "Invalid Comment Block: Missing Header"
"            return 0
"        endif
"
"        "-----------------------------------------------------------------------
"        " If we found a footer line, we must not be in a comment block
"        "-----------------------------------------------------------------------
"        if cur_line =~ footer_regex
"            echo "Not in comment block"
"            return 0
"        endif
"
"        let first_line -= 1
"    endwhile
"
"    if first_line <= 0 
"        echo "Header Missing"
"        return 0
"    endif
"
"    "---------------------------------------------------------------------------
"    " Find the footer of the comment
"    "---------------------------------------------------------------------------
"    while last_line <= line( '$' )
"        let cur_line = getline( last_line )
"        
"        if cur_line =~ footer_regex
"            break
"        endif
"
"        if cur_line !~ line_regex
"            echo "Invalid Comment Block: Missing Footer"
"            return 0
"        endif
"
"        let last_line += 1
"    endwhile
"
"    if last_line > line( '$' )
"        echo "Footer Missing"
"        return 0
"    endif
"
"    "---------------------------------------------------------------------------
"    " If there are no lines to be gotten rid of, return success, but do
"    " nothing
"    "---------------------------------------------------------------------------
"    if first_line == last_line
"        return 1
"    endif
"
"    "---------------------------------------------------------------------------
"    " Calculate the new Cursor Position
"    "---------------------------------------------------------------------------
"
"    if cur_cursor_line > first_line && cur_cursor_line < last_line
"        let cur_cursor_col = cur_cursor_col - ( strlen( leader ) + leader_spacing )
"    endif
"    
"    if cur_cursor_line > first_line 
"        let cur_cursor_line -= 1
"    endif
"
"    if cur_cursor_line >= last_line
"        let cur_cursor_line -= 1
"    endif
"
"    "---------------------------------------------------------------------------
"    " Delete the header
"    "---------------------------------------------------------------------------
"    call cursor( first_line, 1 )
"    norm dd
"    let last_line -= 1
"
"    "---------------------------------------------------------------------------
"    " Delete the footer
"    "---------------------------------------------------------------------------
"    call cursor( last_line, 1 )
"    norm dd
"    let last_line -= 1
"
"    "---------------------------------------------------------------------------
"    " Remove the leader from all the rest of the lines
"    "---------------------------------------------------------------------------
"    for i in range( first_line, last_line )
"        let cur_line = getline( i )
"        let indent = match( cur_line, '[^\t ]' )
"
"        let replacement = substitute( cur_line, escape( leader, '*.\' ) . '[ ]\{' . leader_spacing . '}', '' , '')
"
"        call setline( i, replacement )
"    endfor
"  
"    "---------------------------------------------------------------------------
"    " Restore the cursor position
"    "---------------------------------------------------------------------------
"    call cursor( cur_cursor_line, cur_cursor_col )
"
"    return 1
"endfunction
"
"function CommentBlock( first_line, last_line, line, col )
"
"    "---------------------------------------------------------------------------
"    " Read the configuration settings
"    "---------------------------------------------------------------------------
"    let introducer = exists("b:comment_introducer") ? b:comment_introducer : "/*"
"    let trailer = exists( "b:comment_trailer" ) ? b:comment_trailer : "*/"
"    let border = exists( "b:comment_border" ) ? b:comment_border : "-"
"    let leader = exists("b:comment_leader") ? b:comment_leader : ""
"    let leader_spacing = exists( "b:comment_leader_spacing" ) ? b:comment_leader_spacing : 0
"    let width = exists( "g:comment_max_col" ) ? g:comment_max_col : 1
"   
"    "---------------------------------------------------------------------------
"    " Get the initial cursor position
"    "---------------------------------------------------------------------------
"    let cur_cursor_col = a:col
"    let cur_cursor_line = a:line
"    
"    let indent = 0
"    
"    let cur_line_num = a:first_line
"
"    "---------------------------------------------------------------------------
"    " Loop backward to find the first non-blank line above the starting line.
"    " Copy the indentation from this line
"    "---------------------------------------------------------------------------
"    while cur_line_num > 0 
"        let cur_line = getline( cur_line_num )
"        if cur_line !~ '^[\t ]*$'
"            let indent = match( cur_line, '[^\t ]' )
"
"            "-----------------------------------------------
"            " If this line is a single parenthesis or
"            " brace, remove the indent
"            "-----------------------------------------------
"            if g:comment_no_closing_indent && cur_line =~ '^[\t ]*[\)\}]'
"                echo "Closing Indent"
"                let indent = indent - &shiftwidth 
"            endif
"            break
"        endif
"
"        let cur_line_num -= 1
"    endwhile
"
"    "-------------------------------------------------------
"    " Ensure indent is not smaller than zero
"    "-------------------------------------------------------
"    if indent < 0 
"        let indent = 0
"    endif
"   
"    "---------------------------------------------------------------------------
"    " Find the longest line that is being commented  
"    "---------------------------------------------------------------------------
"    for linenum in range( a:first_line, a:last_line )
"        let cur_line = getline( linenum )
"        let length = strlen( cur_line ) + leader_spacing + strlen( leader )
"
"        if length > width 
"            let width = length
"        endif
"    endfor
"
"    "---------------------------------------------------------------------------
"    " Remove the indentation and the length of the introducer to determine the
"    " border size
"    "---------------------------------------------------------------------------
"    let width = width - ( indent + strlen( introducer ) )
"
"    "---------------------------------------------------------------------------
"    " Set the minimum comment width  
"    "---------------------------------------------------------------------------
"    if exists( "g:comment_min_width" ) && width < g:comment_min_width
"        let width = g:comment_min_width
"    endif
"
"    "---------------------------------------------------------------------------
"    " Comment out the lines, keeping their original indentation
"    "---------------------------------------------------------------------------
"    for linenum in range( a:first_line, a:last_line )
"        let cur_line = getline( linenum )
"        let cur_indent = match( cur_line, "[^\t ]" )
"
"        if cur_indent >= indent
"            let cur_indent = indent
"        endif
"        
"        let replacement = repeat( ' ', indent ) . leader . repeat( ' ', leader_spacing ) . cur_line[ cur_indent : strlen( cur_line ) ]
"
"        call setline( linenum, replacement )
"    endfor
"
"    "---------------------------------------------------------------------------
"    " Insert the header line
"    "---------------------------------------------------------------------------
"    call cursor( a:first_line, 1 )
"    exe "put! = ''"
"    call setline( a:first_line, repeat( ' ', indent ) . introducer . repeat( border, width ) ) 
"
"
"    "---------------------------------------------------------------------------
"    " Insert the footer line
"    "---------------------------------------------------------------------------
"    if exists( "b:comment_leader_in_footer" ) && b:comment_leader_in_footer
"        let footer_str = repeat( ' ', indent ) . leader . repeat( border, width - strlen( leader ) ) . trailer
"    else
"        let footer_str = repeat( ' ', indent ) . repeat( border, width ) . trailer
"    endif
"    
"    call cursor( a:last_line + 1, 1 )
"    exe "put = ''"
"    call setline( a:last_line + 2, footer_str )
"
"
"    "---------------------------------------------------------------------------
"    " Calculate the new cursor position
"    "---------------------------------------------------------------------------
"    if a:line >= a:first_line
"        let cur_cursor_line = cur_cursor_line + 1
"    endif
"
"    if a:line > a:last_line
"        let cur_cursor_line = cur_cursor_line + 1
"    endif
"
"    if a:line >= a:first_line && a:line <= a:last_line
"        let cur_cursor_col = cur_cursor_col + strlen( leader ) + leader_spacing
"    endif
"
"    call cursor( cur_cursor_line, cur_cursor_col )
"
"endfunction
"
"function OmniComment( line, col ) range
"    if ! UnCommentBlock( a:firstline, a:lastline, a:line, a:col )
"        call CommentBlock( a:firstline, a:lastline, a:line, a:col )
"    endif
"endfunction
"
let g:loaded_comments = 1

