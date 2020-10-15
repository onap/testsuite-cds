#!/usr/bin/python

import sys
import json


if __name__ == "__main__":
    ansibleArtifacts = json.loads(sys.argv[1])
    interfaceName = ansibleArtifacts["topology"]["tor-8.tenlab-cloud"][0]["interface_name"]
    print(interfaceName)
    sys.exit(0)
