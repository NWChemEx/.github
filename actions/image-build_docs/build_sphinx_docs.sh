#!/bin/sh

cd ${GITHUB_ACTION_PATH}/../../docs

if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt
fi
make html
