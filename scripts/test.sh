#!/bin/sh

rm -rf examples/output
rm src/main/wingspkg/lang/*Config.nim
git checkout src/main/wingspkg/lang/psqlConfig.nim
./pleasew run --show_all_output //src/main/staticlang:static
./pleasew run --show_all_output //src/main:wings -- examples/input/student.wings examples/input/place.wings examples/input/sample_interface.wings examples/input/homework_logger.wings examples/input/emotion_change_logger.wings -c:wings.json

STATUS=$(git status examples/output/ src/main/wingspkg/lang --porcelain)
if [ "$STATUS" != "" ]; then
    echo "$STATUS"
    echo
    echo "Some files are changed after running genFile(). If this is intentional, please include those changes in your commit."
    git --no-pager diff
    exit 1
fi
