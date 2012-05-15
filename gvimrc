" vim:fo-=a

if has("win16") || has("win32") || has("win64")|| has("win95")
    " get normal ALT-SPACE behavior 
    map <M-Space> :simalt ~<CR>
    set gfn=Lucida_Sans_Typewriter:h18:cANSI
elseif has("gui_macvim")
    set gfn=Menlo:h15
endif

set cursorline   " highlight line cursor is on



set guioptions-=T    " no toolbar

" must be set in vimrc rather than vimrc - they're values are reset when
" gvim starts
set vb t_vb= 


function! JamesTabLabel() 
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
      if getbufvar(bufnr, "&modified")
        let label = '+'
        break
      endif
    endfor

    " Append the number of windows in the tab page if more than one
    " let wincount = tabpagewinnr(v:lnum, '$')
    " if wincount > 1
    "   let label .= wincount
    " endif
    " if label != ''
    "   let label .= ' '
    " endif
    " ^ commented out because it includes taglist window in count
    "   an enhancement would be to filter it out

    let fileName = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])

    " show only the filename (get rid of all the path details)
    let fileName = substitute(fileName, ".*/", "", "")


    " 'escape' ampersands, so they 1) aren't hidden
    "  & 2) make character following them underlined
    let fileName = substitute(fileName, "&", "&&", "g")

    " don't show '.txt' extensions
    let fileName = substitute(fileName, "\\.txt$", "", "")

    let label = label . fileName

    return label
endfunction

set guitablabel=%{JamesTabLabel()}


function! OpenMyFiles()
    " note that for filepaths, must use forwards-slashes
    let notesDir      = "~/Notes"
    let phdWorkingDir = "~/PhD/working"
    let dropBoxDir    = "~/Dropbox"
    let fileList = [ 
        \ notesDir      . "/2012-plan.txt", 
        \ notesDir      . "/2012-days.txt", 
        \ dropBoxDir    . "/PlainText/plan.txt",
        \ notesDir      . "/vim.txt",
        \ notesDir      . "/compu.txt",
        \ notesDir      . "/aiya,univData.txt",
        \ notesDir      . "/thinking&Knowl.txt",
        \ notesDir      . "/writing.txt",
        \ notesDir      . "/postQueue.txt",
        \ notesDir      . "/otherIdeas.txt",
        \ notesDir      . "/biograph.txt",
        \ notesDir      . "/I-F&Games.txt",
        \ notesDir      . "/food&drinks.txt",
        \ notesDir      . "/artsRelated.txt",
        \ phdWorkingDir . "/phdNotesInclSources.txt"
        \ ]
    for fileName in fileList
        exec "e " . fileName
        exec "tabe"
    endfor
    exec "tabc"
    exec "tabdo :TlistToggle"
    " now, put the focus on the days file 
    exec "normal! 2gt"
endfunction


" dev notes:
" originally I didnt have the command there to join the lines, and it 
" didnt work properly.  the reason was that you can't call exec like that
" when there are a range of lines specified on the command line, as there
" will be because there is a selection - and that sucks.  the only
" reasonable option would be if i could just put the 's' command there
" without putting it as an arg to the exec...which i tried but it didnt 
" seem to work.  if you use the substitute function, it only works on a 
" per-line basis, which'd be a pain.  
" could ask vim-use if there's a better way to do this.
function! ConvertStringToFileName()
    normal! gv
    normal! J
    exec "s#\\<\\l#\\u&#ge"
    normal! gv
    exec "s/ //ge"
    exec "s/:/-/ge"
endfunction


" kinda silly way to impl this - I dont know how to define it as a string
" and just insert that string.  dont know how to encode the linebreaks. but
" it works.
function! InsertNotesFileFields()
    let oldFo = &fo
    set fo-=a
    normal! O
    normal! otitle=
    normal! oauthor=
    normal! otype=
    normal! oyear=
    normal! otopics=
    normal! oread=
    normal! o
    normal! o
    normal! o----------
    normal! o
    let &fo = oldFo
endfunction


" requires the input text to be visual selection
function! CleanTranslinkResult()
    let stringsToRemove = "Take Bus\\|\\t\\|(.\\{-})\\|daily timetable\\|trip timetable\\|Departing\\|Arriving\\|Zones travelled in:.*$\\|Fares for this journey.*$\\|Fare included in the next trip.*$" 
    normal! gv
    exec "'<,'>s/" . stringsToRemove . "//ge"
endfunction


function! WrapAllLines()
    let oldTw = &tw
    let &tw = 9000
    normal! gg
    normal! gqG
    let &tw = oldTw
endfunction



"== menus

function! OpenMyFiles_MenuItem()
    call OpenMyFiles()
    amenu disable &Personal.&Open\ Standard\ Files
endfunction

amenu 900.100 &Personal.&Open\ Standard\ Files    :<C-U>silent call OpenMyFiles_MenuItem()<CR>

amenu 900.110 &Personal.&Format\ XML :<C-U>silent call FormatXml()<CR>

amenu 900.120 &Personal.&Convert\ String\ To\ File\ Name :<C-U>silent call ConvertStringToFileName()<CR>

amenu 900.140 &Personal.Clean\ &Translink\ Result :silent call CleanTranslinkResult()<CR>

amenu 900.150 &Personal.&Insert\ Notes\ File\ Fields :silent call InsertNotesFileFields()<CR>

amenu 900.160 &Personal.&Wrap\ All\ Lines :silent call WrapAllLines()<CR>

" eventually i want to put ticks next to the selected ones ✓

amenu 900.170 &Personal.W&riting\ Mode.&Normal :silent call NormalWritingModeLinesAndLinespace()<CR>

amenu 900.180 &Personal.W&riting\ Mode.&Drafting :silent call DraftingWritingModeLinesAndLinespace()<CR>
