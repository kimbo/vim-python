function! python#Error(msg)
	execute 'normal! \<Esc>'
	echohl ErrorMsg
	echomsg 'python-vim: ' . a:msg
	echohl None
endfunction
 
function! python#Run()
	if filereadable('./venv/bin/python')
		let pythonbin = 'venv/bin/python'
		:terminal ./venv/bin/python "%"
	else
		:terminal python "%"
	endif
endfunction

function! python#Breakpoint()
	let lineno = line('.')
	let line = getline(lineno - 1)
	if line =~ '^\s*import pdb; pdb.set_trace().*'
		execute ':' . lineno - 1
		d
	else
		if line =~ '^.*:\s*$'
			let extra = '    '
		else
			let extra = ''
		endif
		call append(lineno - 1, substitute(line, '^\(\s*\).*$', '\1' . extra . 'import pdb; pdb.set_trace()', ''))
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
			":s/^\(\s*\)#\s*/\1/
			let changedline = substitute(line, '^\(\s*\)#\s*', '\1', '')
		else
			":s/^\(\s*\)/\1# /
			let changedline = substitute(line, '^\(\s*\)', '\1# ', '')
		endif
		call setline(currentline, changedline)
		let currentline = currentline + 1
	endwhile
endfunction

command! PyRun call python#Run()
command! PyBreakpoint call python#Breakpoint()
command! -range -bar PyCommentVisual call python#Comment(1)
command! -range -bar PyCommentNormal call python#Comment(0)

autocmd BufNewFile,BufReadPost *.py nnoremap <F4> :PyBreakpoint <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <F5> :PyRun <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <c-_> :PyCommentNormal <CR>
autocmd BufNewFile,BufReadPost *.py xnoremap <c-_> :PyCommentVisual <CR>

