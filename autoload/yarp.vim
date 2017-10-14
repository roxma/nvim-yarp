let s:id = 1
let s:reg = {}

func! yarp#py3(module)
    let rp = yarp#_new()
    let rp.type = 'py3'
    let rp.module = a:module
    func rp.init()
        if has_key(self, 'job')
            return
        endif
        call call('yarp#pyx#init', [], self)
    endfunc
    return rp
endfunc

func! yarp#py(module)
    let rp = yarp#_new()
    let rp.type = 'py'
    let rp.module = a:module
    func rp.init()
        if has_key(self, 'job')
            return
        endif
        call call('yarp#pyx#init', [], self)
    endfunc
    return rp
endfunc

func! yarp#_new()
    let s:id = s:id + 1
    let rp = {}
    let rp.call = function('s:request')
    let rp.request = function('s:request')
    let rp.notify = function('s:notify')
    let rp.wait_channel = function('s:wait_channel')
    let rp.id = s:id
    let s:reg[rp.id] = rp
    return rp
endfunc

func! yarp#_channel_started(id, channel)
    let s:reg[a:id].channel = a:channel
endfunc

func! yarp#on_stderr(chan_id, data, event)
endfunc

func! yarp#_serveraddr()
    let addr = get(g:, 'yarp_serveraddr', '')
    if addr
        return addr
    endif
    if has('nvim')
        return v:servername
    endif
    " vim8 support
    return neovim_rpc#serveraddr()
endfunc

func! yarp#_jobstart(...)
    if exists('*jobstart')
        let jobstart = 'jobstart'
    else
        let jobstart = get(g:, 'yarp_jobstart', 'neovim_rpc#jobstart')
    endif
    return call(jobstart, a:000)
endfunc

func! s:wait_channel(self)
    let self = a:self
    while ! has_key(self, 'channel')
        sleep 20m
    endwhile
endfunc

func! s:request(method, ...) dict
    call self.init()
    call s:wait_channel(self)
    if exists('*rpcrequest')
        let rpcrequest = 'rpcrequest'
    else
        let rpcrequest = get(g:, 'yarp_rpcrequest', 'neovim_rpc#rpcrequest')
    endif
    return call(rpcrequest, [self.channel, a:method] + a:000)
endfunc

func! s:notify(method, ...) dict
    call self.init()
    call s:wait_channel(self)
    if exists('*rpcnotify')
        let rpcnotify = 'rpcnotify'
    else
        let rpcnotify = get(g:, 'yarp_rpcnotify', 'neovim_rpc#rpcnotify')
    endif
    call call(rpcnotify, [self.channel, a:method] + a:000)
endfunc

