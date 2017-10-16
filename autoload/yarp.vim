
func! yarp#py3(module)
    let rp = yarp#core#new()
    let rp.type = 'py3'
    let rp.module = a:module
    let rp.init = function('yarp#pyx#init')
    return rp
endfunc

func! yarp#py(module)
    let rp = yarp#core#new()
    let rp.type = 'py'
    let rp.module = a:module
    let rp.init = function('yarp#pyx#init')
    return rp
endfunc

