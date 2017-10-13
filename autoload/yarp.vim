
func! yarp#py3(module)
    let ret = {}
    let ret.type = 'py3'
    let ret.module = a:module
    let ret.call = function('s:request')
    let ret.request = function('s:request')
    let ret.notify = function('s:notify')
    let ret.init = function('yarp#pyx#init')
    return ret
endfunc

func! yarp#py(module)
    let ret = {}
    let ret.type = 'py'
    let ret.module = a:module
    let ret.call = function('s:request')
    let ret.request = function('s:request')
    let ret.notify = function('s:notify')
    let ret.init = function('yarp#pyx#init')
    return ret
endfunc


func! s:request(method, ...) dict
    call self.init()
    return call('rpcrequest', [self.channel, a:method] + a:000)
endfunc

func! s:notify(method, ...) dict
    call self.init()
    call call('rpcnotify', [self.channel, a:method] + a:000)
endfunc

func! yarp#on_stderr(chan_id, data, event)
endfunc

