from bottle import abort, run, Bottle, static_file, TEMPLATE_PATH, template, request
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

FRM_HUMAN_F = 0
FRM_HUMAN_M = 1
FRM_GIANT_F = 2
FRM_GIANT_M = 3


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
        i = int(i.strip(u'\ufeff'))
        locale[name][int(i)] = n.strip('\r\n')
    lines.close()
    t2 = time.clock()
    print "Locale file %s loaded in %f sec" % (fname, t2 - t1)


def get_local_name(name):
    if name[:3] == u'_LT':
        _, name, n = name[4:-1].split('.')
        load_locale_file(name)
        if int(n) in locale[name]:
            return locale[name][int(n)]
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
    #sex = {'male': list(), 'female': list()}
    #item = {'human': deepcopy(sex), 'giant': deepcopy(sex), 'elf': deepcopy(sex)}
    item = {FRM_HUMAN_F: list(), FRM_HUMAN_M: list(), FRM_GIANT_F: list(), FRM_GIANT_M: list()}
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
            if name is None: name = i[1].attrib['Text_Name0']
            t = i[1].attrib['App_WearType']
            e = entry.copy()
            e['name'] = name.strip('@')
            if equip == 'body':
                if len(t) > 2: e['t3'] = encrypt(t[2])
                if len(t) > 1: e['t2'] = encrypt(t[1])
                if len(t) > 0: e['t1'] = encrypt(t[0])
            else:
                try:
                    e['t1'] = int(t)-1
                except ValueError:
                    e['t1'] = t[0]
            if 'File_FemaleMesh' in i[1].attrib:
                e['fname'] = encrypt(i[1].attrib['File_FemaleMesh'] + '.pmg')
                db[equip][FRM_HUMAN_F] += [e]
            if 'File_MaleMesh' in i[1].attrib:
                e['fname'] = encrypt(i[1].attrib['File_MaleMesh'] + '.pmg')
                db[equip][FRM_HUMAN_M] += [e]
            if 'File_FemaleGiantMesh' in i[1].attrib:
                e['fname'] = encrypt(i[1].attrib['File_FemaleGiantMesh'] + '.pmg')
                db[equip][FRM_GIANT_F] += [e]
            if 'File_GiantMesh' in i[1].attrib:
                e['fname'] = encrypt(i[1].attrib['File_GiantMesh'] + '.pmg')
                db[equip][FRM_GIANT_M] += [e]
    for frm in range(4):
        db['body'][frm] = sorted(db['body'][frm], key=lambda e: e['name'])
        db['hand'][frm] = sorted(db['hand'][frm], key=lambda e: e['name'])
        db['foot'][frm] = sorted(db['foot'][frm], key=lambda e: e['name'])
        db['head'][frm] = sorted(db['head'][frm], key=lambda e: e['name'])
        db['robe'][frm] = sorted(db['robe'][frm], key=lambda e: e['name'])
    t2 = time.clock()
    print "Loaded DB in", t2 - t1, "sec"


def print_params(route):
    for k, v in request.query.allitems():
        print route, "GET", k, v
    for k, v in request.forms.allitems():
        print route, "POST", k, v

@app.route('/cs/serve.x/<name>')
def callback(name):
    print name
    if name[-2:] == '.z':
        res = assets.get_x_file(name[:-2])
        if res is not None:
            return res
        else:
            print "Not found"
            pass
    abort(404, "Not found")


@app.route('/main', method=['POST', 'GET'])
def callback():
    print_params("/main")
    return template('main.tpl')


@app.route('/control')
def callback():
    print_params("/control")
    frm = request.query.framework
    if frm == '': frm = FRM_GIANT_M
    frm = int(frm)
    body = db['body'][frm]
    hand = db['hand'][frm]
    foot = db['foot'][frm]
    head = db['head'][frm]
    robe = db['robe'][frm]
    return template('control.tpl', body=body, hand=hand, foot=foot, head=head, robe=robe)


@app.route('/')
def callback():
    print_params("/")
    control_opt = ''
    frm = request.query.framework
    if frm != '': control_opt = "?framework=" + frm
    else: frm = 3
    return template('index.tpl', framework=int(frm), control_opt=control_opt)


@app.route('/<path:path>')
def callback(path):
    #print path
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
    #run(app=app,port=80)
    print "Starting web server..."
    server = wsgiserver.CherryPyWSGIServer(
        ('127.0.0.1', 80), app,
        server_name='')
    print "Started"
    server.start()

if __name__ == "__main__": main()