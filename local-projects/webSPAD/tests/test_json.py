#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import requests
import json

url = 'http://localhost:4242/json'
payload = {'code': 'D(x^n,x,4)'}

r = requests.post(url, data=payload)

print(r.text)

data = r.text
data = data.replace('\r','\\r')
data = data.replace('\n','\\n')
data = json.loads(data.rstrip('\\n'))

print data['input']
print data['charybdis']
print data['spad-type']