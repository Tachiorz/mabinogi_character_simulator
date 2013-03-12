from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import time
import package

assets = None

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        name = self.path.split("/")[-1][:-2]
        self.send_response(200)
        self.end_headers()
        self.wfile.write(assets.get_x_file(name))
    def do_POST(self):
        print "POST", self.path

def main():
    global assets
    server = None

    print "Loading game assets..."
    t1 = time.clock()
    assets = package.mabi_assets("..\\package\\")
    t2 = time.clock()
    print "Loaded in", t2 - t1, "sec"
    if assets is None: exit(0)

    print "Starting web server..."
    try:
        server = HTTPServer(("localhost", 80), MyHandler)
        print "Started"
        server.serve_forever()
    except KeyboardInterrupt:
        print "Shutdown requested..."
        server.socket.close()

if __name__ == "__main__": main()
