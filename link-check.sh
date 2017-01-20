#!/bin/sh

virtualenv .venv
source .venv/bin/activate
pip install -Ur requirements.txt

./site preview&

while ! tcping -q localhost 8000; do
  sleep 1
done

linkchecker http://localhost:8000
res=$?

deactivate

pkill site

exit $res
