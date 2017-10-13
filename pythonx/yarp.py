from neovim import attach
import sys
import importlib

module = sys.argv[1]
module_obj = None

nvim = attach('stdio')
sys.modules['vim'] = nvim
sys.modules['nvim'] = nvim

paths = nvim.eval(r'globpath(&rtp,"pythonx",1) . "\n" .'
                  r' globpath(&rtp,"rplugin/python3",1)')
for path in paths.split("\n"):
    if not path:
        continue
    if path not in sys.path:
        sys.path.append(path)

module_obj = importlib.import_module(module)


def on_request(method, args):
    if hasattr(module_obj, method):
        return getattr(module_obj, method)(*args)
    else:
        raise Exception('method %s not found' % method)


def on_notification(method, args):
    if hasattr(module_obj, method):
        getattr(module_obj, method)(*args)
    else:
        raise Exception('method %s not found' % method)
    pass


def on_setup():
    pass


nvim.run_loop(on_request, on_notification, on_setup)
