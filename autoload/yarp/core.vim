
let s:id = 1
let s:reg = {}

func! yarp#core#new()
    let s:id = s:id + 1
    let rp = {}
    let rp.call = function('yarp#core#request')
    let rp.request = function('yarp#core#request')
    let rp.notify = function('yarp#core#notify')
    let rp.wait_channel = function('yarp#core#wait_channel')
    let rp.id = s:id
    let s:reg[rp.id] = rp
    return rp
endfunc

func! yarp#core#on_stderr(chan_id, data, event) dict
endfunc

func! yarp#core#channel_started(id, channel)
    let s:reg[a:id].channel = a:channel
endfunc

func! yarp#core#request(method, ...) dict
    call self.init()
    call self.wait_channel()
    if exists('*rpcrequest')
        let rpcrequest = 'rpcrequest'
    else
        let rpcrequest = get(g:, 'yarp_rpcrequest', 'neovim_rpc#rpcrequest')
    endif
    return call(rpcrequest, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#notify(method, ...) dict
    call self.init()
    call self.wait_channel()
    if exists('*rpcnotify')
        let rpcnotify = 'rpcnotify'
    else
        let rpcnotify = get(g:, 'yarp_rpcnotify', 'neovim_rpc#rpcnotify')
    endif
    call call(rpcnotify, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#wait_channel() dict
    while ! has_key(self, 'channel')
        sleep 20m
    endwhile
endfunc

func! yarp#core#jobstart(...)
    if exists('*jobstart')
        let jobstart = 'jobstart'
    else
        let jobstart = get(g:, 'yarp_jobstart', 'neovim_rpc#jobstart')
    endif
    return call(jobstart, a:000)
endfunc

func! yarp#core#serveraddr()
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

