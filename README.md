
# Yet Another Remote Plugin Framework for Neovim

This is my attempt on writing a remote plugin framework without
`:UpdateRemotePlugins`.

## Requirements

- `has('python3')`
- For vim8 support,
  [roxma/vim-hug-neovim-rpc](https://github.com/roxma/vim-hug-neovim-rpc)

## Usage

pythonx/hello.py

```python
import vim, time
def greet():
    time.sleep(3)
    vim.command('echo "Hello world"')
```

plugin/hello.vim

```vim
" Create a python3 process running the hello module. The process is lazy load.
let s:hello = yarp#py3('hello')

com HelloSync call s:hello.request('greet')
com HelloAsync call s:hello.notify('greet')

" You could type :Hello greet
com -nargs=1 Hello call s:hello.request(<f-args>)
```
