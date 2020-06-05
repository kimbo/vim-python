function! python#Error(msg)
	execute 'normal! \<Esc>'
	echohl ErrorMsg
	echomsg 'python-vim: ' . a:msg
	echohl None
endfunction

function! python#Success(msg)
	execute 'normal! \<Esc>'
	echohl Function
	echomsg 'python-vim: ' . a:msg
	echohl None
endfunction

function! python#SetArgs()
	let args = input('Arguments: ', "", "file")
	let g:pyargs = split(args, '\s+')
	call python#Success('Arguments set')
endfunction

function! python#Run(...)
	let cmd = ':terminal'
	if filereadable('./venv/bin/python')
		let cmd = cmd . " " . './venv/bin/python'
	else
		let cmd = cmd . " " . 'python'
	endif
	let cmd = cmd . " " . "%"
	let i = 1
	while i < argc()
		echo "" . i . ": " . argv(i)
		let cmd = cmd . " " . argv(i)
		let i = i + 1
	endwhile
	if exists('g:pyargs') && len(g:pyargs) > 0
		let extraargs = join(g:pyargs, " ")
		let cmd = cmd . " " . extraargs
	endif
	call python#Success(cmd)
	execute cmd
endfunction

function! python#Breakpoint()
	let lineno = line('.')
	let line = getline(lineno - 1)
	if line =~ '^\s*import pdb; pdb.set_trace().*'
		execute ':' . lineno - 1
		d
		call python#Success('Breakpoint removed')
	else
		if line =~ '^.*:\s*$'
			let extra = '    '
		else
			let extra = ''
		endif
		call append(lineno - 1, substitute(line, '^\(\s*\).*$', '\1' . extra . 'import pdb; pdb.set_trace()', ''))
		call python#Success('Breakpoint set')
	endif
endfunction

function! python#Comment(visual)
	if a:visual == 1
		execute 'normal! gv'
		let firstline = line("'<")
		let lastline = line("'>")
	else
		let firstline = a:firstline
		let lastline = a:lastline
	endif
	if firstline > lastline
		let temp = firstline
		let firstline = lastline
		let lastline = temp
	endif
	let currentline = firstline
	while currentline <= lastline
		let line = getline(currentline)
		if line =~ '^\s*#.*'
			let changedline = substitute(line, '^\(\s*\)#', '\1', '')
		else
			let changedline = substitute(line, '^', '#', '')
		endif
		call setline(currentline, changedline)
		let currentline = currentline + 1
	endwhile
endfunction

function! python#SetArgsAndRun()
	execute ':PySetArgs'
	execute ':PyRun'
endfunction

command! PyRun call python#Run(<f-args>)
command! PyBreakpoint call python#Breakpoint()
command! -range -bar PyCommentVisual call python#Comment(1)
command! -range -bar PyCommentNormal call python#Comment(0)
command! PySetArgs call python#SetArgs()
command! PyRunWithArgs call python#SetArgsAndRun()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SUGGESTED MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd BufNewFile,BufReadPost *.py nnoremap <F3> :PySetArgs <CR>
" autocmd BufNewFile,BufReadPost *.py nnoremap <F4> :PyBreakpoint <CR>
" autocmd BufNewFile,BufReadPost *.py nnoremap <F5> :PyRun <CR>
" autocmd BufNewFile,BufReadPost *.py nnoremap <F6> :PyRunWithArgs <CR>
" autocmd BufNewFile,BufReadPost *.py nnoremap <c-_> :PyCommentNormal <CR>
" autocmd BufNewFile,BufReadPost *.py xnoremap <c-_> :PyCommentVisual <CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
