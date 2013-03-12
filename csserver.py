from bottle import abort, run, Bottle, static_file, TEMPLATE_PATH, template
import time, webbrowser
import package

assets = None
TEMPLATE_PATH.insert(0,'tpl')
app = Bottle()

@app.route('/cs/serve.x/<name>')
def callback(name):
    print name
    if name[-2:] == '.z': return assets.get_x_file(name[:-2])
    abort(404, "Not found")

@app.route('/main', method=['POST','GET'])
def callback():
    return template('main.tpl')

@app.route('/control')
def callback():
    return template('control.tpl')

@app.route('/')
def callback():
    return template('index.tpl')

@app.route('/<path:path>')
def callback(path):
    return static_file(path, root="static")

def main():
    global assets

    print "Loading game assets..."
    t1 = time.clock()
    assets = package.mabi_assets("..\\package\\")
    t2 = time.clock()
    print "Loaded in", t2 - t1, "sec"
    if assets is None: exit(0)
    ie = webbrowser.get(webbrowser.iexplore)
    ie.open('localhost')
    run(app=app,port=80)

if __name__ == "__main__": main()