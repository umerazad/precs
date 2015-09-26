#!/bin/bash

find . -name '*.py[co]' -type f -exec rm -f '{}' ';'
find . -name '__pycache__' -type d -print0 | xargs -0 rm -r --
