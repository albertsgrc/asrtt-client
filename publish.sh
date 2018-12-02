#!/usr/bin/env bash

rm -rf build
rm -rf dist
rm -rf __pycache__
rm -rf asrtt.egg-info
python3 setup.py sdist bdist_wheel
twine upload dist/* 