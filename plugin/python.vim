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

function! python#Comment()
	let l:mode = mode()
	echo l:mode
	if l:mode == "V"
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
command! -range -bar PyComment call python#Comment()

autocmd Filetype python nnoremap <F4> :PyBreakpoint <CR>
autocmd Filetype python nnoremap <F5> :PyRun <CR>
autocmd Filetype python xnoremap <c-_> :PyComment <CR>

