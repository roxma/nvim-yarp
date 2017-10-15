
func! yarp#pyx#init() dict
    if self.type == 'py'
        let exe = s:pyexe()
    else
        let exe = s:py3exe()
    endif

    if get(s:, 'script', '') == ''
        let s:script = globpath(&rtp,'pythonx/yarp.py',1)
    endif

    let cmd = [exe, s:script, yarp#_serveraddr(), self.id, self.module]
    let opts = {'on_stderr': function('yarp#on_stderr')}
    let self.cmd = cmd
    let self.job = yarp#_jobstart(cmd, opts)
    return
endfunc

func! s:pyexe()
    if get(g:, '_yarp_py', '')
        return g:_yarp_py
    endif
	let g:_yarp_py = get(g:,'python_host_prog','')
    if g:_yarp_py == '' && has('nvim') && has('python')
        " heavy weight
        " but better support for python detection
        python import sys
        let g:_yarp_py = pyeval('sys.executable')
    endif
    if g:_yarp_py == ''
        let g:_yarp_py = 'python2'
    endif
    return g:_yarp_py
endfunc

func! s:py3exe()
    if get(g:, '_yarp_py3', '')
        return g:_yarp_py3
    endif
	let g:_yarp_py3 = get(g:,'python3_host_prog','')
    if g:_yarp_py3 == '' && has('nvim') && has('python3')
        " heavy weight
        " but better support for python detection
        python3 import sys
        let g:_yarp_py3 = py3eval('sys.executable')
    endif
    if g:_yarp_py3 == ''
        let g:_yarp_py3 = 'python3'
    endif
    return g:_yarp_py3
endfunc

