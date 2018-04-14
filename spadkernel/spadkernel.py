#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# Reference:
# http://jupyter-client.readthedocs.io/en/stable/wrapperkernels.html

from ipykernel.kernelbase import Kernel
from subprocess import Popen
import requests
import json
import os

path = os.path.abspath(__file__)
dir_path = os.path.dirname(path)

class httpSPAD():

    def __init__(self, url = 'http://localhost:4242/json'):
        # Store parameters
        self.url = url
        self.output = None
        # Start FriCAS/Axiom
        
        
    def put(self, code):
        payload = {'code': code}
        r = requests.post(self.url, data=payload)
        data = r.text
        data = data.replace('\r','\\r')
        data = data.replace('\n','\\n')
        self.output = json.loads(data.rstrip('\\n'))
        

class SPAD(Kernel):
    implementation = 'SPAD'
    implementation_version = '1.0'
    language = 'SPAD'
    language_version = '0.1'
    language_info = {'name': 'SPAD', 'mimetype': 'text/plain',
                     'file_extension': '.spad',}
    banner = "SPAD kernel - FriCAS, [Open]Axiom"
    
    
    def __init__(self, **kwargs):
        Kernel.__init__(self, **kwargs)
        self.server = httpSPAD()


    def do_execute(self, code, silent, store_history=True, 
                   user_expressions=None, allow_stdin=False):

        self.server.put(code)

        if not silent:
            output = self.server.output['charybdis']
            stream_content = {'name': 'stdout', 'text': output}
            self.send_response(self.iopub_socket, 'stream', stream_content)

        return {'status': 'ok',
                # The base class increments the execution count
                'execution_count': self.execution_count,
                'payload': [],
                'user_expressions': {},
               }

if __name__ == '__main__':
    from ipykernel.kernelapp import IPKernelApp
    IPKernelApp.launch_instance(kernel_class=SPAD)


# Here’s the Kernel spec kernel.json file for this:
#
# {"argv":["python","-m","spadkernel", "-f", "{connection_file}"],
#  "display_name":"SPAD"
# }
#    
# install it using 
#   jupyter kernelspec install </path/to/kernel>. 
# Place your kernel module anywhere Python can import it 
# (try current directory for testing). 
# Finally, you can run your kernel using 
#  jupyter console --kernel SPAD. 
# 

