" lifthrasiir's .vimrc file (r21, 2008-11-16)
"" written by Kang Seonghoon <lifthrasiir@gmail.com>
"" This file is placed in the public domain.
"" =========================================================

scripte utf-8
set nocp all&

" UTILITY FUNCTIONS {{{ ------------------------------------
" maps key to the command in insert, normal, and (if vmap=1) visual mode
fu! s:Map(key, value, vmap)
	exe 'imap <silent> ' . a:key . ' <C-\><C-O>' . a:value
	exe 'nmap <silent> ' . a:key . ' ' . a:value
	if a:vmap | exe 'vmap <silent> ' . a:key . ' <Esc>' . a:value . 'gv' | endif
endf

" maps two keys to the command if needed. used for mac's Command key
fu! s:Map2(key1, key2, value, vmap)
	call s:Map(a:key1, a:value, a:vmap)
	if has("macunix") | call s:Map(a:key2, a:value, a:vmap) | endif
endf

" maps key to the function
fu! s:MapFunc(key, fname, vmap)
	call s:Map(a:key, ':call <SID>' . a:fname . '()<CR>', a:vmap)
endf

" creates the directory if not exists
fu! s:MakeDir(path)
	if glob(a:path) == ''
		try
			call mkdir(a:path, 'p')
		catch /^Vim(mkdir):/
		endtry
	endif
endf
" }}} ------------------------------------------------------

" TERMINAL {{{ ---------------------------------------------
if &term =~ "xterm"
	set t_Co=8
	if has("terminfo")
		let &t_Sf = "\<Esc>[3%p1%dm"
		let &t_Sb = "\<Esc>[4%p1%dm"
	else
		let &t_Sf = "\<Esc>[3%dm"
		let &t_Sb = "\<Esc>[4%dm"
	endif
endif

" terminal encoding (always use utf-8 if possible)
if !has("win32") || has("gui_running")
	set enc=utf-8 tenc=utf-8
	if has("win32")
		set tenc=cp949
		let $LANG = substitute($LANG, '\(\.[^.]\+\)\?$', '.utf-8', '')
	endif
endif
if &enc ==? "euc-kr"
	set enc=cp949
endif
" }}} ------------------------------------------------------

" EDITOR {{{ -----------------------------------------------
set nu ru sc wrap ls=2 lz                " -- appearance
set noet bs=2 ts=8 sw=8 sts=0            " -- tabstop
set noai nosi hls is ic cf ws scs magic  " -- search
set sol sel=inclusive mps+=<:>           " -- moving around
set ut=10 uc=200                         " -- swap control
set report=0 lpl wmnu                    " -- misc.

" encoding and file format
set fenc=utf-8 ff=unix ffs=unix,dos,mac
set fencs=utf-8,cp949,cp932,euc-jp,shift-jis,big5,latin2,ucs2-le

" list mode
set nolist lcs=extends:>,precedes:<
if &tenc ==? "utf-8"
	set lcs+=tab:»\ ,trail:·
else
	set lcs+=tab:\|\
endif
" }}} ------------------------------------------------------

" TEMPORARY/BACKUP DIRECTORY {{{ ---------------------------
set swf nobk bex=.bak
if exists("$HOME")
	" makes various files written into ~/.vim/ or ~/_vim/
	let s:home_dir = substitute($HOME, '[/\\]$', '', '')
	if has("win32")
		let s:home_dir = s:home_dir . '/_vim'
	else
		let s:home_dir = s:home_dir . '/.vim'
	endif
	if exists('*mkdir') && v:version >= 700
		" automatically create directories for first time
		call s:MakeDir(s:home_dir)
		call s:MakeDir(s:home_dir . '/tmp')
		call s:MakeDir(s:home_dir . '/backup')
	endif
	if isdirectory(s:home_dir)
		let &dir = s:home_dir . '/tmp,' . &dir
		let &bdir = s:home_dir . '/backup,' . &bdir
		let &vi = &vi . ',n' . s:home_dir . '/viminfo'
	endif
endif
" }}} ------------------------------------------------------

" KEY MAPPING {{{ ------------------------------------------
set wak=no                          " -- no alt menu mapping
set noto ttimeout tm=3000 ttm=100   " -- input timeout
let mapleader = '\'

" moving around and editing
map <MiddleMouse> <Nop>
map! <MiddleMouse> <Nop>
vmap <Tab> >gv
vmap <S-Tab> <gv
fu! s:HomeKey() " -- home key correction
	let l:column = col('.') | exe "norm ^"
	if l:column == col('.') | exe "norm 0" | endif
endf
call s:MapFunc('<Home>', 'HomeKey', 0)

" switching around buffer
map <F11> :bn<CR>
map <F12> :bN<CR>
if has("macunix")
	map <D-F11> :bn<CR>
	map <D-F12> :bN<CR>
endif

" make search appears in the middle of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" immediate buffer configuration
map <silent> <Leader>n :let &nu = 1 - &nu<CR>
map <silent> <Leader>l :let &list = 1 - &list<CR>
map <silent> <Leader>p :let &paste = 1 - &paste<CR>
map <silent> <Leader>w :let &wrap = 1 - &wrap<CR>
nmap <silent> <Leader>1 :set ts=1 sw=1<CR>
nmap <silent> <Leader>2 :set ts=2 sw=2<CR>
nmap <silent> <Leader>4 :set ts=4 sw=4<CR>
nmap <silent> <Leader>8 :set ts=8 sw=8<CR>

" editing and applying .vimrc
if has("win32")
	nmap <silent> <Leader>R :so $HOME/_vimrc<CR>
	nmap <silent> <Leader>rc :e $HOME/_vimrc<CR>
else
	nmap <silent> <Leader>R :so $HOME/.vimrc<CR>
	nmap <silent> <Leader>rc :e $HOME/.vimrc<CR>
endif

" inserting matching quotes
fu! s:InputQuotes()
	if mode() == "R"
		exe "normal \<Esc>" | return ""   " -- beep
	elseif match(getline("."), '\%u2018\%'.col('.').'c\%u2019') < 0
		return "\u2018\u2019\<Insert>\<BS>\<Insert>"
	else
		return "\<Del>\<BS>\u201c\u201d\<Insert>\<BS>\<Insert>"
	endif
endf
imap <silent> <C-'> <C-R>=<SID>InputQuotes()<CR>

" misc. mapping
nmap <silent> <Leader>cd :cd %:p:h<CR>
nmap <silent> <Leader><Space> :noh<CR>

" }}} ------------------------------------------------------

" ABBRIVATION {{{ ------------------------------------------
if has("digraphs")
	dig +< 12296 >+ 12297 <+ 12298 +> 12299
endif
" }}} ------------------------------------------------------

" GUI {{{ --------------------------------------------------
if has("gui_running")
	set go+=c go-=t go-=m go-=T sel=inclusive
	set lines=40 co=100 lsp=0
	set mouse=a  " --TODO
	"colo desert
	if has("transparency")
		set transp=5
	endif

	" font fix
	if has("win32")
		silent! set gfn=Raize:h10 gfw=DotumChe:h11 lsp=-1
		silent! set gfn=NanumGothicCoding:h10 gfw= lsp=0
	elseif has("macunix")
		silent! set macatsui gfn=Monaco:h12 gfw=AppleGothic\ Regular:h13
	endif

	" toggle menubar
	fu! s:MenuBar()
		if stridx(&go, 'm') == -1
			set go+=T go+=m
		else
			set go-=T go-=m
		endif
	endf
	call s:MapFunc('<M-F10>', 'MenuBar', 1)

	" toggle smaller and bigger font
	let s:fontenlarged = 0
	fu! s:FontSize()
		if s:fontenlarged
			let &gfn = substitute(&gfn, '\(:h\)\@<=\d\+', '\=submatch(0)/2', 'g')
			let &gfw = substitute(&gfw, '\(:h\)\@<=\d\+', '\=submatch(0)/2', 'g')
			exe ':winp ' . s:oldwinposx . ' ' . s:oldwinposy
			let &lines = s:oldlines | let &columns = s:oldcolumns
		else
			let s:oldwinposx = getwinposx() | let s:oldwinposy = getwinposy()
			let s:oldlines = &lines | let s:oldcolumns = &columns
			let &gfn = substitute(&gfn, '\(:h\)\@<=\d\+', '\=submatch(0)*2', 'g')
			let &gfw = substitute(&gfw, '\(:h\)\@<=\d\+', '\=submatch(0)*2', 'g')
		endif
		let s:fontenlarged = 1 - s:fontenlarged
	endf
	map <silent> <Leader>f :call <SID>FontSize()<CR>

	" launching console
	if has("win32")
		fu! s:Console(path)
			let l:path = iconv(a:path, &enc, &tenc)
			silent exe "! start /d \"" . a:path . "\""
		endf
	elseif has("macunix")
		fu! s:Console(path)
			let l:path = iconv(a:path, &enc, &tenc)
			silent exe "!open -a iTerm . && osascript -e 'tell application " .
				\ "\"iTerm\" to tell the last terminal to tell current sess" .
				\ "ion to write text \"cd '\\''" . a:path . "'\\''; clear\"'"
		endf
	else
		fu! s:Console(path)
			echoerr ".vimrc: " . mapleader . "C is not enabled here."
		endf
	endif
	nmap <silent> <Leader>C :call <SID>Console(expand("%:p:h"))<CR>
else
	" update terminal title
	set title titlestring=%{$USER}@%{hostname()}:\ %F\ (%l/%L)\ -\ VIM
endif

" share vim's own clipboard with system clipboard
if has("gui_running") || has("xterm_clipboard")
	set cb=unnamed
endif

" macvim specific
"   we cannot use has("gui_macvim") because normal vim also
"   requires this change.
if match($VIM, 'MacVim\.app') >= 0
	set imd
endif
" }}} ------------------------------------------------------

" SYNTAX {{{ -----------------------------------------------
syn enable
syn sync maxlines=1000
filet plugin indent on
let php_sync_method = 0
let html_wrong_comments = 1

" syntax extensions
fu! s:SyntaxExtHTML()
	" HTML CDATA section
	syn region htmlCdataSection matchgroup=htmlCdataDecl start=+<!\[CDATA\[+ end=+\]\]>+
	syn cluster htmlTop add=htmlCdataSection
	hi def link htmlCdataDecl htmlTag
endf
" }}} ------------------------------------------------------

" AUTOCMD {{{ ----------------------------------------------
if has("autocmd")
	aug vimrc
	au!

	" filetype-specific configurations
	au FileType python setl ts=8 sw=4 sts=4 et
	au Filetype text setl tw=80
	au FileType javascript,jsp setl cin colorcolumn=80
	au BufNewFile,BufRead *.phps,*.php3s setf php
	au BufNewFile,BufRead *.markdown,*.md,*.mdown,*.mkd,*.mkdn
		\ if &ft =~# '^\%(conf\|modula2\)$' |
		\   set ft=markdown |
		\ else |
		\   setf markdown |
		\ endif

	" syntax extensions (see prior section for definition)
	au Syntax html call s:SyntaxExtHTML()

	" restore cursor position when the file has been read
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "norm g`\"" |
		\ endif

	" fix window position for mac os x
	if has("gui_running") && has("macunix")
		au GUIEnter *
			\ if getwinposx() < 50 |
			\   exe ':winp 50 ' . (getwinposy() + 22) |
			\ endif
	endif

	" fix window size if window size has been changed
	if has("gui_running")
		fu! s:ResizeWindows()
			let l:nwins = winnr("$") | let l:num = 1
			let l:curtop = 0 | let l:curleft = 0
			let l:lines = &lines - &cmdheight
			let l:prevlines = s:prevlines - &cmdheight
			let l:cmd = ""
			while l:num < l:nwins
				if l:curleft == 0
					let l:adjtop = l:curtop * l:lines / l:prevlines
					let l:curtop = l:curtop + winheight(l:num) + 1
					if l:curtop < l:lines
						let l:adjheight = l:curtop * l:lines / l:prevlines - l:adjtop - 1
						let l:cmd = l:cmd . l:num . "resize " . l:adjheight . "|"
					endif
				endif
				let l:adjleft = l:curleft * &columns / s:prevcolumns
				let l:curleft = l:curleft + winwidth(l:num) + 1
				if l:curleft < &columns
					let l:adjwidth = l:curleft * &columns / s:prevcolumns - l:adjleft - 1
					let l:cmd = l:cmd . "vert " . l:num . "resize " . l:adjwidth . "|"
				else
					let l:curleft = 0
				endif
				let l:num = l:num + 1
			endw
			exe l:cmd
		endf
		fu! s:ResizeAllWindows()
			if v:version >= 700
				let l:tabnum = tabpagenr()
				tabdo call s:ResizeWindows()
				exe "norm " . l:tabnum . "gt"
			else
				call s:ResizeWindows()
			endif
			let s:prevlines = &lines | let s:prevcolumns = &columns
		endf
		au GUIEnter * let s:prevlines = &lines | let s:prevcolumns = &columns
		au VimResized * call s:ResizeAllWindows()
	endif

	aug END
endif
" }}} ------------------------------------------------------

" VIM7 SPECIFIC {{{ ----------------------------------------
if v:version >= 700
	" editor setting
	set nuw=6

	" omni completition
	set ofu=syntaxcomplete#Complete
	imap <C-Space> <C-X><C-N>

	" key mapping for tabpage
	call s:Map2('<C-Tab>', '<D-Down>', 'gt', 0)
	call s:Map2('<C-t>', '<D-Down>', 'gt', 0)
	call s:Map2('<C-S-Tab>', '<D-Up>', 'gT', 0)
	call s:Map2('<C-y>', '<D-Down>', 'gT', 0)
	let i = 1
	while i <= 10
		call s:Map2('<M-' . (i % 10) . '>', '<D-' . (i % 10) . '>', i . 'gt', 0)
		let i = i + 1
	endw
	call s:Map2('<M-n>', '<D-n>', ':tabnew<CR>', 0)
	call s:Map2('<M-w>', '<D-w>', ':tabclose<CR>', 0)

	" session management
	fu! s:SaveSession()
		let l:path = $HOME
		if isdirectory(l:path . '/Desktop')
			let l:path .= '/Desktop'
		endif
		let l:path = input('Where to save the session? ', l:path, 'dir')
		if l:path != ''
			let l:path .= '/session'
			if glob(l:path) != ''
				let l:suffix = 0
				while glob(l:path . '.' . l:suffix) != ''
					let l:suffix += 1
				endwhile
				let l:path .= '.' . l:suffix
			endif
			exe 'mks ' . l:path
			echo 'Saved the session: ' . l:path
		endif
	endf
	fu! s:RestoreSession()
		let l:path = $HOME
		if isdirectory(l:path . '/Desktop')
			let l:path .= '/Desktop'
		endif
		let l:path .= '/session'
		let l:path = input('What session to be recovered? ', l:path, 'file')
		if l:path != ''
			exe 'so ' . l:path
			echo 'Recovered the session: ' . l:path
		endif
	endf
	nmap <silent> <Leader>ss :call <SID>SaveSession()<CR>
	nmap <silent> <Leader>sr :call <SID>RestoreSession()<CR>

	" automatic session recovery
	fu! s:SearchSession()
		let l:tmpdirs = strpart(&dir, 0, stridx(&dir, ','))
		for i in split(globpath(l:tmpdirs, '**/*.sw?'), '\n')
			" vim swap file format is defined in src/memline.c. highlight is
			" that file name starts at offset 108, and at least up to 850
			" bytes are available for it. (some add. info is at end of it)
			let l:path = substitute(strpart(join(readfile(i, 'b', 512), "\n"),
										  \ 108, 512), '\n*$', '', '')
			exe 'tabnew' l:path
		endfo
	endf
	" TODO
	"call s:SearchSession()
endif
" }}} ------------------------------------------------------

" shell
set shell=bash

" tabstop settings
set ts=4
set et
set sw=4

" dein
"if &compatible
"    set nocompatible
"endif
set runtimepath^=~/.vim/bundle/dein.vim/
call dein#begin(expand('~/.vim/bundle/'))

call dein#add('Shougo/vimproc.vim',
              \ {
              \   'build' : {
              \     'linux': 'make',
              \     'unix': 'gmake',
              \     'mac': 'make',
              \     'windows': 'tools\\update-dll-mingw',
              \     'cygwin': 'make -f make_cygwin.mak',
              \   },
              \ })
call dein#add('tpope/vim-fugitive')
call dein#add('altercation/vim-colors-solarized')
"call dein#add('jade.vim')
call dein#add('sjl/gundo.vim')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('scrooloose/syntastic')
call dein#add('Valloric/ListToggle')
call dein#add('rust-lang/rust.vim')
call dein#add('Valloric/YouCompleteMe',
              \ {
              \   'install_process_timeout': 1000,
              \   'build' : {
              \      'linux': './install.py --racer-completer --clang-completer --system-libclang',
              \      'unix': './install.py',
              \      'mac': './install.py',
              \     'windows': 'install.py',
              \     'cygwin': './install.py',
              \   },
              \ })
call dein#add('scrooloose/nerdtree')
call dein#add('Xuyuanp/nerdtree-git-plugin')
call dein#add('Nopik/vim-nerdtree-direnter')
call dein#add('ctrlpvim/ctrlp.vim')
"call dein#add('Nonius/cargo.vim')
call dein#add('d3m3vilurr/clippy.vim',
              \ {
              \   'build' : {
              \     'linux': './install.sh',
              \   },
              \ })
call dein#add('vim-scripts/let-modeline.vim')
call dein#add('leafgarland/typescript-vim')

call dein#end()
filetype plugin indent on

if dein#check_install()
    call dein#install()
endif

" solarized
set background=dark
let g:solarized_termtrans=1
colorscheme solarized

" sudo write
ca w!! w !sudo tee >/dev/null "%"

" trailing whitespace
call s:Map('<F4>', ':FixWhitespace<CR>', 0)

" gundo
call s:Map('<F5>', ':GundoToggle<CR>', 0)
let g:gundo_write = 60
let g:gundo_preview_height = 40
let g:gundo_right = 1

" Fugitive
call s:Map('<C-g>s', ':Git status<CR>', 0)
call s:Map('<C-g>c', ':Git commit<CR>', 0)
call s:Map('<C-g>d', ':Git diff<CR>', 0)
call s:Map('<C-g>l', ':Git log<CR>', 0)
call s:Map('<C-g>w', ':Git write<CR>', 0)
call s:Map('<C-g>b', ':Git blame<CR>', 0)
call s:Map('<C-g>e', ':Git edit<CR>', 0)

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_rust_checkers = ['rustc', 'clippy']
let g:syntastic_typescript_checkers = ['tsc', 'tslint']
let g:syntastic_typescript_tsc_fname = ''

" ListToggle
let lt_location_list_toggle_map = '<C-s>d'
call s:Map('<C-s>j', ':lnext<CR>', 0)
call s:Map('<C-s>k', ':lprevious<CR>', 0)

" YouCompleteMe
let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:Show_diagnostics_ui = 1 "default 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1
let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''

let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
let g:ycm_confirm_extra_conf = 1

let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
"let g:ycm_key_invoke_completion = '<C-Space>'

call s:Map('<M-F11>', ':YcmForceCompileAndDiagnostics<CR>', 0)

" NERDTree
let NERDTreeMapOpenInTab='<ENTER>'
call s:Map('<F2>', ':NERDTreeToggle<CR>', 0)

" CtrlP"
let g:ctrlp_map = '<F3>'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-t>'],
            \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
            \ }

" end of configuration
finish

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CHANGELOGS:
" 2005-10-13  initial revision
" 2005-12-18  added various settings from barosl's .vimrc
"             set custom temporary directory
"             synchronized system clipboard with vim register
" 2006-01-24  maps euc-kr encoding to cp949
" 2006-05-11  added fold marker and home key correction
"             ignores error when the font doesn't exist
"             added shortcut for vim7 tabpage
" 2006-05-12  explicit <Leader> mapping
"             added some utility functions and \R, \rc, \cd
"             removed redundant menubars (toggle with M-F10)
"             added support for vim7 omni completition
" 2006-06-17  added \w, \4 and \8, \f shortcut
" 2006-07-03  changed win32 terminal encoding to utf-8
"             uses bigger DotumChe for wide font
" 2006-08-11  made search appears in the middle of the screen
"             added shiftwidth option to \4 and \8
" 2006-08-13  added \C shortcut for win32 console
" 2006-09-07  set html_wrong_comments for invalid HTMLs
" 2006-10-08  fixed minor bug of \8 (wrong shiftwidth)
" 2007-03-19  fixed bugs on non-win32 platforms
" 2007-05-28  added support for mac os x (font setting, etc)
" 2007-06-16  merged r12 (2007-03-19) and r13 (2007-05-28)
"             added more comments and changelogs (finally!)
"             changed overall structure of the script
"             added \C command for mac os x
" 2007-07-03  adds <D-..> only in mac os x (failed otherwise)
"             got \f shortcut working in non-win32 platforms
" 2007-07-29  adds \<Space>, <C-'> shortcuts; changed ffs order
"             fixed \C bug and window disposition in mac os x
"             automatic proportional resizing of windows
" 2008-03-08  automatic session restoration. (experimental)
" 2008-06-02  added some digraphs
" 2008-07-11  added \1 and \2 shortcut
" 2008-08-09  creates .vim directory automatically if not exist
"             added \ss, \sr shortcuts for session save&load
" 2008-09-08  macvim specific changes (and IME problem fixed)
" 2008-11-16  added html <![CDATA[]]> section highlighting
" 2009-06-30  d3m3vilurr fork
" 2009-12-21  set et, ts=4, sw=4
" 2011-06-10  added setting Pathogen, solarized
" 2011-10-17  added setting vimroom
" 2011-11-17  remove setting mswin
" 2011-11-22  added sudo write
"
" TODOS:
" - integrated ctags support
" - more filetype-specific configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" vim: ts=4 sw=4 fdm=marker nofen
