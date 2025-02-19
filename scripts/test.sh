#!/bin/sh

rm -rf examples/output
rm src/main/wingspkg/lang/*Config.nim
nim c -r -d:ssl src/main/staticlang/main.nim
nim c -r -d:ssl src/main/wings.nim examples/input/student.wings examples/input/place.wings examples/input/sample_interface.wings -c:wings.json

STATUS=$(git status examples/output/ src/main/wingspkg/lang --porcelain)
if [ "$STATUS" != "" ]; then
    echo "$STATUS"
    echo
    echo "Some files are changed after running genFile(). If this is intentional, please include those changes in your commit."
    git --no-pager diff
    exit 1
fi
