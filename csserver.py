from bottle import abort, run, Bottle, static_file, TEMPLATE_PATH, template
from cherrypy import wsgiserver
from StringIO import StringIO
from xml.etree.ElementTree import iterparse
from copy import deepcopy
import time, webbrowser
from encrypt import encrypt
import package

assets = None
locale = dict()
db = dict()
framework = 3
TEMPLATE_PATH.insert(0, 'tpl')
app = Bottle()


def load_locale_file(name):
    if name in locale: return
    global locale
    t1 = time.clock()
    fname = 'xml\\' + name + '.english.txt'
    l = assets.get_file(fname)
    lines = StringIO(unicode(l, 'utf-16-le'))
    locale[name] = dict()
    for l in lines:
        i, n = l.split('\t')
        locale[name][i] = n.strip('\r\n')
    lines.close()
    t2 = time.clock()
    print "Locale file %s loaded in %f sec" % (fname, t2 - t1)


def get_local_name(name):
    if name[:3] == '_LT':
        _, name, n = name[4:-1].split('.')
        load_locale_file(name)
        if n in locale[name]:
            return locale[name][n]
        else: return None
    else:
        return name


def load_db():
    global db
    print "Loading DB..."
    t1 = time.clock()
    itemdb = assets.get_file('db\\itemdb.xml')
    itemdb = StringIO(itemdb)
    entry = {'name': "", 'fname': "", 't1': "", 't2': "", 't3': ""}
    sex = {'male': list(), 'female': list()}
    item = {'human': deepcopy(sex), 'giant': deepcopy(sex), 'elf': deepcopy(sex)}
    db['body'] = deepcopy(item)
    db['hand'] = deepcopy(item)
    db['foot'] = deepcopy(item)
    db['head'] = deepcopy(item)
    db['robe'] = deepcopy(item)
    body = '/equip/armor/'
    hand = '/equip/hand/'
    foot = '/equip/foot/'
    head = '/equip/head/'
    robe = '/equip/robe/'
    items = iterparse(itemdb)
    for i in items:
        if 'Category' in i[1].attrib:
            if i[1].attrib['Category'][:len(body)] == body: equip = 'body'
            elif i[1].attrib['Category'][:len(hand)] == hand: equip = 'hand'
            elif i[1].attrib['Category'][:len(foot)] == foot: equip = 'foot'
            elif i[1].attrib['Category'][:len(head)] == head: equip = 'head'
            elif i[1].attrib['Category'][:len(robe)] == robe: equip = 'robe'
            else: continue
            name = get_local_name(i[1].attrib['Text_Name1'])
            if name is None: name = get_local_name(i[1].attrib['Text_Name0'])
            t = i[1].attrib['App_WearType']
            e = entry.copy()
            e['name'] = name
            if equip == 'body':
                if len(t) > 2: e['t3'] = encrypt(t[2])
                if len(t) > 1: e['t2'] = encrypt(t[1])
                if len(t) > 0: e['t1'] = encrypt(t[0])
            else:
                e['t1'] = t[0]
            if 'File_GiantMesh' in i[1].attrib:
                e['fname'] = encrypt(i[1].attrib['File_GiantMesh'] + '.pmg')
                db[equip]['giant']['male'] += [e]
    t2 = time.clock()
    print "Loaded DB in", t2 - t1, "sec"


@app.route('/cs/serve.x/<name>')
def callback(name):
    print name
    if name[-2:] == '.z':
        res = assets.get_x_file(name[:-2])
        if res is not None:
            return res
        else:
            print "Not found"
    abort(404, "Not found")


@app.route('/main', method=['POST','GET'])
def callback():
    return template('main.tpl')


@app.route('/control')
def callback():
    race = 'giant'
    sex = 'male'
    if framework == 3:
        race, sex = 'giant', 'male'
    body = db['body'][race][sex]
    hand = db['hand'][race][sex]
    foot = db['foot'][race][sex]
    head = db['head'][race][sex]
    robe = db['robe'][race][sex]
    return template('control.tpl', body=body, hand=hand, foot=foot, head=head, robe=robe)


@app.route('/')
def callback():
    return template('index.tpl')


@app.route('/<path:path>')
def callback(path):
    print path
    return static_file(path, root="static")


def main():
    global assets

    print "Loading game assets..."
    t1 = time.clock()
    assets = package.mabi_assets("..\\package\\")
    t2 = time.clock()
    print "Loaded in", t2 - t1, "sec"
    if assets is None: exit(0)
    load_db()
    ie = webbrowser.get(webbrowser.iexplore)
    ie.open('localhost')
    run(app=app,port=80)
    print "Starting web server..."
    server = wsgiserver.CherryPyWSGIServer(
        ('127.0.0.1', 80), app,
        server_name='')
    print "Started"
    server.start()

if __name__ == "__main__": main()