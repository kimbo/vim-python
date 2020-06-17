# python-vim

Little vim plugin for python

# Installation

```
git clone https://github.com/kimbo/vim-python.git ~/.vim/pack/plugins/start/vim-python
```

# Usage

The suggested way to use vim-python is to define some mappings in your ~/.vimrc:
```vimscript
autocmd BufNewFile,BufReadPost *.py nnoremap <F3> :PySetArgs <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <F4> :PyBreakpoint <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <F5> :PyRun <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <F6> :PyRunWithArgs <CR>
autocmd BufNewFile,BufReadPost *.py nnoremap <c-_> :PyCommentNormal <CR>
autocmd BufNewFile,BufReadPost *.py xnoremap <c-_> :PyCommentVisual <CR>
```

You can customize these to map to whatever keys you want.

# Features

Here's a table that describes the features/functions that vim-python provides.

Function name | Description | Suggested mapping from above
---|---|---
`:PySetArgs` | Set the arguments to be used when `:PyRun` is invoked | **F3**
`:PyBreakpoint` | Toggle a breakpoint on/above the current line. This just inserts `import pdb; pdb.set_trace()` | **F4**
`:PyRun` | Run the current file as a Python script. If ./venv/bin/python exists, it will be the interpreter chosen. Otherwise, the default `python` is used | **F5**
`:PyRunWithArgs` | Set the arguments to be run, and then run the current file as a Python script. This combines `:PySetArgs` and `:PyRun` for convenience | **F6**
`:PyCommentNormal` and `:PyCommentVisual` | Toggle comment on the current line or visual selection | **Ctrl+/**
