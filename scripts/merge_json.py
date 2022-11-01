# merging 2 json
import json
import sys
import os

# able to merge json with multiple levels of attributes
def selective_merge(base_obj, delta_obj):
    if not isinstance(base_obj, dict):
        return delta_obj
    common_keys = set(base_obj).intersection(delta_obj)
    new_keys = set(delta_obj).difference(common_keys)
    for k in common_keys:
        base_obj[k] = selective_merge(base_obj[k], delta_obj[k])
    for k in new_keys:
        base_obj[k] = delta_obj[k]
    return base_obj

if (len(sys.argv)-1 < 3):
    raise ValueError('Script requires 3 filenames to process, 2 for input and 1 for output')

input_json_filename = sys.argv[1]
base_json_filename = sys.argv[2]
output_json_filename = sys.argv[3]

if (os.path.isfile(input_json_filename) and os.access(input_json_filename, os.R_OK)):
    with open(input_json_filename, encoding='utf-8') as f:
        dMerge = json.loads(f.read())
else:
    print ("Either file {} is missing or is not readable, assuming empty file...".format(input_json_filename))
    dMerge = {}

if (os.path.isfile(base_json_filename) and os.access(base_json_filename, os.R_OK)):
    with open(base_json_filename, encoding='utf-8') as f:
        dBase = json.loads(f.read())
else:
    print ("Either file  {}  is missing or is not readable, assuming empty file...".format(base_json_filename))
    dBase = {}
    
# output file
with open(output_json_filename, 'w', ) as f:
    dMerged = selective_merge(dBase,dMerge)
    json.dump(dMerged, f, ensure_ascii=False, indent=4)



