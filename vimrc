" vim:fo-=a


set nocompatible


"== pathogen
call pathogen#runtime_append_all_bundles() 


filetype plugin indent on 



set autowriteall   " auto save the file on things like :next

set switchbuf=usetab,newtab


" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

if version >= 500

  " highlight strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch

endif



set shiftwidth=4
set softtabstop=4
set expandtab

set linebreak      " dont linebreak inside words
set mousehide	   " hide the mouse when typing text
set splitbelow


"== search related
set ignorecase smartcase
set incsearch
function! NoHLSearch(pat)
   call search(a:pat)
   set nohls
   set hls
endfunction
" command -nargs=1 S :call NoHLSearch(<f-args>)
" F5 - toggle highlight search
map <F5> :set hls!<bar>set hls?<CR>


" unicode - for hars pasted from web-pages, PDFs etc (see usr_45.txt)
set encoding=utf-8


" ** actualyl these sould be defined in vimrc and called in there to set
" the default that is set when vim is run.
function! NormalWritingModeLinesAndLinespace()
    set lines=32
    set linespace=5
endfunction

function! DraftingWritingModeLinesAndLinespace()
    set lines=21
    set linespace=13
endfunction


"== syntax/display
set columns=75
" set lines=38
" now setting it to less as i've increased linespace
" set lines=32
" set linespace=5
call NormalWritingModeLinesAndLinespace()
set ch=2		" Make command line two lines high
set laststatus=2   " so last remaining window always has a statusline
" make closed folds less visually prominent
highlight Folded guifg=LightBlue
function! MyFoldText()
    let leadingSpaces = "                                                                   "
    return leadingSpaces . "\\" . (v:foldend - v:foldstart)
endfunction
set foldtext=MyFoldText()
" note that the following has a backslash followed by one space
set fillchars=fold:\ 
highlight statusline guibg=LightGray guifg=DarkGray gui=none
set statusline=
set statusline+=%{getline(search(\"^:\",\ \"bnW\"))}   " show curr heading
set statusline+=%=                                     " show rest right justified.
set statusline+=\ \ %c\,\ %l\ (%L)                     " col, line (tot lines)
highlight CursorLine guibg=#D9D9D9
"colorscheme morning
set background=light   " for solarized
colorscheme solarized



set backup          " turn on backup
set backupdir=/Temp/vimFileBackups    " dir for tilde files
set dir=/Temp/vimSwapFiles     " dir for swap files 
" mustn't have trailing slash. otherwise subsequent additions wont work 
set path+=~/Notes
set path+=~/PhD


set autoindent


set browsedir=current       " open file browser in current dir 

set selectmode=key



"== snipmate options
let g:snips_author = "James Cole" 


"== taglist options
let g:Tlist_Auto_Open=1
set updatetime=100
let Tlist_WinWidth = 50
let tlist_txt_settings  = 'txt;h:headings'
nnoremap <silent> <F9> :TlistToggle<CR>
" To not display the Vim fold column in the taglist window
let g:Tlist_Enable_Fold_Column = 0
" only show contents of the current file in current tab
let g:Tlist_Show_One_File = 1

" weird, my computer crashed and after restarting it would no longer 
" generate the tags. it'd say 
" Taglist: Failed to generate tags for /my/path/to/file
"   ctags: illegal option -- -^@usage: ctags [-BFadtuwvx] [-f tagsfile] file ...
" Taglist FAQ says this is coz its not using the exuberant ctags file.
" if i type ctags in shell it gets exuberant one...
" but anyway i recently installed oh-my-zsh, which might be somehow the 
" problem.  setting the following var fixes the prob
" This seems to be about this problem (though I didn't it all):
" http://vim.1045645.n5.nabble.com/MacVim-and-PATH-td3388705.html
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" C-s saves and updates tagslist 
nnoremap <silent> <C-s> :silent w<BAR>:silent TlistUpdate<CR>
inoremap <silent> <C-s> <C-o>:silent w<CR><ESC>:silent TlistUpdate<CR>

"== tabbar options
let g:tagbar_expand = 1
let g:tagbar_updateonsave_maxlines = 7000



"== scrolling 
imap <C-E> <C-O><C-E>
set sidescroll=1   " smooth horizontal scrolling - 1 char at a time
set scrolloff=1


"== cut and paste
" set clipboard+=unnamed    " copy yanks and deletions to system clipboard 
" send all yanked text to the system clipboard
nnoremap y "+y
" a 'cut' operator that can be used with text-objects, where cut text
" is placed on the system clipboard.
nmap \u "+d


" F4 - show list of headings in document
map <F4> :g/^:/<CR>

" F6 - change all the non-displayed chars to plain-text equivs
"    (note how have to escape pipes between commands, and
"     double escape pipes within replace commands)
map <F6> :%s//--/ge \| %s//.../ge  \| %s/\\|/"/ge  \|  %s/\\|/'/ge<CR>


" F7 - to condense selected lines
" very quick a dirty way to do it, should put all the words in a datastructure
" and handle words and their variants ending with s better
map <silent> <F7> :s/\<and\>/\&/ge  \| '<,'>s/\<that\>/tt/ge \| '<,'>s/\<between\>/b\/ween/ge \| '<,'>s/\<with\>/w\//ge \| '<,'>s/\<information\>/info/ge \| '<,'>s/\<computation\>/compu/ge \| '<,'>s/\<are\>/r/ge \| '<,'>s/\<picture\>/pic/ge \| '<,'>s/\<to\>/2/ge \| '<,'>s/\<into\>/in2/ge \| '<,'>s/\<be\>/b/ge \| '<,'>s/\<defined\>/defn'd/ge \| '<,'>s/\<for\>/4/ge \| '<,'>s/\<However\>/Howevr/ge \| '<,'>s/\<definition\>/defn /ge \| '<,'>s/\<particular\>/partic/ge \| '<,'>s/\<thing\>/thng/ge \| '<,'>s/\<things\>/thngs/ge \| '<,'>s/\<which\>/whch/ge \| '<,'>s/\<part\>/prt/ge \| '<,'>s/\<argument\>/arg/ge \| '<,'>s/\<you\>/u/ge\| '<,'>s/\<want\>/wnt/ge \| '<,'>s/\<other\>/othr/ge \| '<,'>s/\<correspond\>/corresp/ge \| '<,'>s/\<for\>/4/ge\| '<,'>s/\<represents\>/reps/ge \| '<,'>s/\<above\>/abve/ge \| '<,'>s/\<character\>/char/ge \| '<,'>s/\<characters\>/chars/ge \| '<,'>s/\<required\>/req'd/ge \| '<,'>s/\<undefined\>/undef'd/ge \| '<,'>s/\<replacement\>/replacemnt/ge \| '<,'>s/\<destination\>/dest/ge \| '<,'>s/\<source\>/src/ge \| '<,'>s/\<your\>/ure/ge \| '<,'>s/\<languages\>/langs/ge \| '<,'>s/\<from\>/frm/ge \| '<,'>s/\<original\>/orig/ge \| '<,'>s/\<about\>/abt/ge \| '<,'>s/\<property\>/prop/ge \| '<,'>s/\<attribute\>/attrib/ge \| '<,'>s/\<question\>/qu/ge \| '<,'>s/\<different\>/diff/ge \| '<,'>s/\<philosophy\>/philos/ge \| '<,'>s/\<implementation\>/impl/ge \| '<,'>s/\<required\>/req'd/ge \| '<,'>s/\<elements\>/elems/ge \| '<,'>s/\<element\>/elem/ge<CR>


" insert '.x' at the start of the line - i've got syntax highlighting so
" that this line is 'crossed off' (as a plain text equiv so strikethrough)
" i use it for my planning docs and the 'to do' sorts of items in it
map <F8> <ESC>I.x <ESC>


" pump out lines below the cursor 
" orig ver: nnoremap <C-i> o<ESC>k
" newer ver that supports counts - see http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)
" nnoremap <C-i> @='o<C-V><ESC>k'<CR>


" execute the selected lines on the ex-line 
" e.g. if those lines contain a function you're coding, or a map
" so you don't have to copy those lines then type ':@"' 
vnoremap x "xy<ESC>:@x<CR>





" note that we may have already deleted some of the files created today..... 
"   e.g. the files from today left might be 
"          100423.txt
"          100423--3.txt
"          100423--4.txt
" and we don't really want to just find the first available sequence num....
" but actually the first one after the current greatest sequence num
function! SaveNewPhdFile()    
    let today = strftime("%y%m%d") 
    let newFileName = today
    let theFileNames = glob(newFileName . "*.txt")
    let suffixes = []
    for fileName in split(theFileNames, "\n")
        let res = matchlist(fileName, "--\\(\\d\\+\\)")
        if res != []
            call add(suffixes, res[1]) 
        " assume it is the unsuffixed file for this date
        else 
            call add(suffixes, 1)        
        endif
    endfor
    " note: max rets 0 on an empty list, which will be case when none of the files had suffixes
    let suffix = max(suffixes) + 1  
    if (suffix > 1)
        let newFileName = newFileName . "--" . suffix . ".txt"
        " ^ for some reason += isnt working  ??
    else
        let newFileName = newFileName . ".txt"
    endif
    exec "w " . newFileName
endfunction

command CreatePhdDocument :call SaveNewPhdFile()

" improvement: hmm, i think i could exec both of these in the one command... and
" whatever is used to separate two commands.. like an ampersand i
" think...thatd guarntee that one only happens after the other and that
" only a single window is used.
function! AddFileToGit()
    exec "silent !git add " . expand("%:p")
    exec "silent !git commit " . expand("%:p") . " -m 'added'"
endfunction
command AddFileToGit :call AddFileToGit()



" @nextAvailable - if '1' attempt to delete the next block of whitespace lines
"   in the given direction, not just any immediately above current line
function! DeleteBlankLinesAboveOrBelow(direction, nextAvailable)
    let currLineNum = getpos(".")[1]
    if (a:nextAvailable == 1)
        let currLineNum = GetNextWhiteSpaceLine(currLineNum, a:direction)
    else
        let currLineNum = Next(currLineNum, a:direction)
    endif
    while (WithinDocument(currLineNum))
        if getline(currLineNum) =~ "^\\s*$"
            exec currLineNum . "delete"
            " note that if we're deleting lines below (direction == 0)
            " then the line numbers below will be one less each time we
            " delete a line
            if (a:direction == 1)
                let currLineNum = Next(currLineNum, a:direction)
            endif
        else
            break
        endif
    endwhile
endfunction

    "  ^ the problem i was having was coz i wasnt reading the documentation of
    "   delete closely enough. i thought you put the line number (or rather,
    "   range) /after/ the delete text. 
    

" the maps stand for 'delete blanks above/below' 
nmap <silent> dba :<C-U>call DeleteBlankLinesAboveOrBelow(1, 0)<CR>
nmap <silent> dbA :<C-U>call DeleteBlankLinesAboveOrBelow(1, 1)<CR>
nmap <silent> dbb :<C-U>call DeleteBlankLinesAboveOrBelow(0, 0)<CR>
nmap <silent> dbB :<C-U>call DeleteBlankLinesAboveOrBelow(0, 1)<CR>

" ^ hmm, if you have these maps as 
"       dsa     (delete space above, etc etc)
"       dsA
"       dsb
"       dsB
"   then for some unknonw reason when you 
"   type 'dd' it pauses before doing it, as if you could be typing 
"   some other thing after it - but none of these start with 'dd' ??
"   but then why can surround.vim not have this effect??


    " @direction:  1 - up, 0 - down
    function! Next(item, direction)
        if (a:direction == 1)
            return a:item - 1
        else
            return a:item + 1
        endif
    endfunction


    function! WithinDocument(lineNum)
        return a:lineNum >= 1 && a:lineNum <= getpos("$")[1]
    endfunction


    function! GetNextWhiteSpaceLine(currLineNum, direction)
        " cases (just in the upwards direction)
        "     - 1. next line above *is* whitespace
        "     - 2. next line above isnt whitespace
        "         - 2.1 whitespace line is N lines above
        "         - 2.2 there are *no* lines of whitespace above
        " 
        "     - 1 & 2 r both handled coz it is passed the line the cursor was
        "       on when deletion command was called, and it just starts looking
        "       from that line 
        "     - the code in general handles 2.1
        "     - the uses of WithinDocument handle 2.2
        let newLineNum = Next(a:currLineNum, a:direction) 
        while ( getline(newLineNum) !~ "^\\s*$" && WithinDocument(newLineNum) )
            let newLineNum = Next(newLineNum, a:direction)
        endwhile
        if !WithinDocument(newLineNum)
            return a:currLineNum
        else
            return newLineNum
        endif
    endfunction
     " *** should really put the regex for whitespace lines into a var!
    " testing map <F4> :<C-U>echo(GetNextWhiteSpaceLine(getpos(".")[1], 1))<CR>


function! FormatXml()
   % !xmllint.exe % --format
endfunction
command FormatXml :call FormatXml()



function! SOnPlural(num)
    if a:num == 1 || a:num == -1
        return ""
    else
        return "s"
endfunction


cd ~/PhD/working/2010-2/


" show the 'cued-up' keys as you type them, eg as you type 3d
set showcmd

" Highlight from start of fileEdit
" most accurate but slowest 
" see http://vim.wikia.com/wiki/Fix_syntax_highlighting 
" autocmd BufEnter * :syntax sync fromstart

set textwidth=9000
set formatoptions-=a

autocmd FileType txt set tw=75
" auto-format as you insert text
autocmd FileType txt set fo+=a
" With this, a linebreak means a new para, unless trailing whitespace at 
" end of line.  It means that the 'a' option doesn't auto join lines 
" separated by a linebreak.
autocmd FileType txt set formatoptions+=w

set hidden
set switchbuf=useopen,usetab

set tabpagemax=35
