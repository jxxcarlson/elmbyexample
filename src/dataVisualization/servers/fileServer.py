#!/usr/bin/env python

"""

Run as `./dataServer.py 8000`.  Be sure that you have
run `chmod u+x server2.py` to make this file executable.
Point your browser to `localhost:8000`.  You will receive
the reply "I don't understand." Now try `localhost:8000/data`.
You will receive the reply the contents of the file `data.txt`.
"""



"""
https://gist.github.com/bradmontgomery/2219997

Very simple HTTP server in python.
Usage::
    ./dummy-web-server.py [<port>]
Send a GET request::
    curl http://localhost:8000/data
Send a HEAD request::
    curl -I http://localhost:800
Send a POST request::
    curl -d "foo=bar&bin=baz" http://localhost:8000
"""

from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import SocketServer
import os

class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()

    def get_data(self, filePath):
        if os.path.exists(filePath):
           with open(filePath, 'rb') as f:
               try:
                  file = open(filePath, "r")
                  return file.read()
               except : # whatever reader errors you care about
                  return "error: file not found"

    def path_data(self, path):
        path_elements = path.split("/")
        print path_elements
        if len(path_elements) != 3:
            return (False, "")
        if path_elements[1] != "data":
            return (False, "")
        return (True, "data/" + path_elements[2])

    def do_GET(self):
        (pathIsVallid, filePath) = self.path_data(self.path)
        if pathIsVallid:
            message = self.get_data(filePath)
        else:
            message = "Invalid request"
        self._set_headers()
        self.wfile.write(message)

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Doesn't do anything with posted data
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")

def run(server_class=HTTPServer, handler_class=S, port=80):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
