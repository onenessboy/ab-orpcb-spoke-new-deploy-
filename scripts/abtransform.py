# From client template to base template transformation
import json
import sys
import os

filepath = "./metadata"
filename = sys.argv[1]
finalpath = os.path.join(filepath, filename)
outfile = finalpath + ".json"

with open(outfile, encoding='utf-8') as f:
    d1 = json.loads(f.read())

with open("./metadata/base.json", encoding='utf-8') as f:
    d2 = json.loads(f.read())

with open("/home/circleci/workingfiles/transformedbase.json", 'w', ) as f:
    for key in d1.keys():
        if key in d2.keys():
            d2[key] = d1[key]
    json.dump(d2, f, ensure_ascii=False, indent=4)
