#!/bin/sh

rm -rf examples/output/go examples/output/kt examples/output/nim examples/output/py examples/output/ts
nimble genFile examples/input/student.wings -c:wings.json

STATUS=$(git status --porcelain)
if [ "$STATUS" != "" ]; then
    echo "$STATUS"
    echo
    echo "Some files are changed after running genFile(). If this is intentional, please include those changes in your commit."
    git --no-pager diff
    exit 1
fi
