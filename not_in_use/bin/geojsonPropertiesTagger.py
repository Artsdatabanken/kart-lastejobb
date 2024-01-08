#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import json

properties = 'properties'
removableProperties = [ 'localId', 'title', 'codes' ]


data = json.load(open(sys.argv[1]))

for feature in data['features']:
    for code in feature[properties]['codes'].split(','):
        feature[properties][code] = ""
    feature[properties]['codes'] = ""
    for removableProperty in removableProperties:
        if removableProperty in feature[properties]:
            if feature[properties][removableProperty] == "": 
                feature[properties].pop(removableProperty, None)

with open(sys.argv[2], 'w') as outfile:
    json.dump(data, outfile)