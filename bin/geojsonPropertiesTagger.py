#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import json

data = json.load(open(sys.argv[1]))

for feature in data['features']:
    for code in feature['properties']['codes']:
        feature['properties'][code] = None
    feature['properties'].pop('codes', None)

with open(sys.argv[2], 'w') as outfile:
    json.dump(data, outfile)