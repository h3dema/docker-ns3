#!/bin/bash
set -e

cd /workspace/bake && ./bake.py configure -e ns-3.19
cd /workspace/bake && ./bake.py check
rm -rf /workspace/bake/source/ns-3.19/ &&  cd /workspace/bake && ./bake.py download
cd /workspace/bake && ./bake.py build
cd /workspace/bake/source/ns-3.19 && ./test.py -c core
cd /workspace/bake/source/ns-3.19 && ./waf --run hello-simulator
