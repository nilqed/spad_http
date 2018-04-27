#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# Reference:
# http://jupyter-client.readthedocs.io/en/stable/wrapperkernels.html

from ipykernel.kernelbase import Kernel
#from subprocess import Popen
import spadkernel.spadtex
import requests
import json
import os

path = os.path.abspath(__file__)
dir_path = os.path.dirname(path)

__version__ = '0.1.0'



class httpSPAD():

    def __init__(self, url = 'http://localhost:4242/json'):
        # Store parameters
        self.url = url
        self.output = None
        
        
    def put(self, code):
        # POST request
        payload = {'code': code}
        r = requests.post(self.url, data=payload)
        data = r.text
        data = data.replace('\\','\\\\')
        data = data.replace('\r','\\r')
        data = data.replace('\n','\\n')
        self.output = json.loads(data.rstrip('\\n'))
        return(r)
        

class SPAD(Kernel):
    implementation = 'SPAD'
    implementation_version = __version__
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

        if code.startswith(")python "):
            self.output = str(eval(code.lstrip(")python ")))
            pyeval = {'name': 'stdout', 'text': self.output}
            self.send_response(self.iopub_socket, 'stream', pyeval)
            return
            
            

        # send code to hunchentoot and get response
        r = self.server.put(code)
        data = dict()
        if r.ok:
            ff = self.server.output['format-flags']
            if ff['tex']=='true':
                tex = self.server.output['tex']
                typ = self.server.output['spad-type']
                #data['text/latex'] = spadkernel.spadtex.makeTeX(tex)
                data['text/latex'] = spadkernel.spadtex.makeTeXType(tex,typ)
            if ff['html']=='true':
                data['text/html'] = self.server.output['html']
            if ff['mathml']=='true':
                data['text/mathml'] = self.server.output['mathml']
                
            
            
        charybdis = self.server.output['charybdis']
        tex = self.server.output['tex']
        spadtype = self.server.output['spad-type'] 
        #data = {'text/latex':tex}
        #data = {'text/plain':charybdis}

        if not silent:
            stdout = {'name': 'stdout', 'text': charybdis}
            self.send_response(self.iopub_socket, 'stream', stdout)
            # Error handling (red)
            #stderr = {'name': 'stderr', 'text': charybdis}
            #self.send_response(self.iopub_socket, 'stream', stderr)
            display_data = {'data':data, 'metadata':{}}
            self.send_response(self.iopub_socket, 'display_data', display_data)


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

