
func! yarp#py3(module)
    let rp = yarp#core#new()
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
    let rp = yarp#core#new()
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

