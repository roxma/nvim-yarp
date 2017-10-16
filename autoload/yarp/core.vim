let s:id = 1
let s:reg = {}

func! yarp#core#new()
    let s:id = s:id + 1

    let rp = {}

    let rp.jobstart = function('yarp#core#jobstart')
    func rp.error(msg) dict
        call yarp#core#error(self.module, a:msg)
    endfunc
    let rp.call = function('yarp#core#request')
    let rp.request = function('yarp#core#request')
    let rp.notify = function('yarp#core#notify')
    let rp.wait_channel = function('yarp#core#wait_channel')
    let rp.id = s:id
    let s:reg[rp.id] = rp

    " reserved for user
    let rp.extra = {}
    return rp
endfunc

func! yarp#core#on_stderr(chan_id, data, event) dict
    let mod = self.self
    call mod.error(filter(a:data, 'len(v:val)'))
endfunc

func! yarp#core#on_exit(chan_id, data, event) dict
    let mod = self.self
    call mod.error("Job is dead.")
endfunc

func! yarp#core#channel_started(id, channel)
    let s:reg[a:id].channel = a:channel
endfunc

func! yarp#core#request(method, ...) dict
    call self.wait_channel()
    if exists('*rpcrequest')
        let rpcrequest = 'rpcrequest'
    else
        let rpcrequest = get(g:, 'yarp_rpcrequest', 'neovim_rpc#rpcrequest')
    endif
    return call(rpcrequest, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#notify(method, ...) dict
    call self.wait_channel()
    if exists('*rpcnotify')
        let rpcnotify = 'rpcnotify'
    else
        let rpcnotify = get(g:, 'yarp_rpcnotify', 'neovim_rpc#rpcnotify')
    endif
    call call(rpcnotify, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#wait_channel() dict
    if has_key(self, 'channel')
        return
    endif
    if ! has_key(self, 'job')
        call self.jobstart()
    endif
    while ! has_key(self, 'channel')
        sleep 20m
    endwhile
endfunc

func! yarp#core#jobstart() dict
    if ! has_key(self, 'cmd')
        call self.init()
        if ! has_key(self, 'cmd')
            call self.error("cmd not set")
            return
        endif
    endif
    if has_key(self, 'job') && self.job >= 0
        return
    endif
    if exists('*jobstart')
        let jobstart = 'jobstart'
    else
        let jobstart = get(g:, 'yarp_jobstart', 'neovim_rpc#jobstart')
    endif
    let opts = {'on_stderr': function('yarp#core#on_stderr'), 'self': self}
    let self.job = call(jobstart, [self.cmd, opts])
    if self.job == -1
        call self.error('Failed starting job: ' . string(self.cmd))
    endif
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

func! yarp#core#error(mod, msg)
    if mode() == 'i'
        " NOTE: side effect, sorry, but this is necessary
        set nosmd
    endif
    if type(a:msg) == type("")
        let lines = split(a:msg, "\n", 1)
    else
        let lines = a:msg
    endif
    echoh ErrorMsg 
    for line in lines
        echom '[ERROR] [' . a:mod . '] ' . line 
    endfor
    echoh None 
endfunc
