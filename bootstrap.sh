#!/bin/bash

VIRTUALENV=${VIRTUALENV:-env}

PIP_ARGS=""
REBUILD="false"
if (($# == 1)); then
    if [ "$1" == "update" ]; then
        PIP_ARGS="-U"
    fi
    if [ "$1" == "refresh" ]; then
        REBUILD="true"
    fi
fi

if [ "$REBUILD" == "true" ]; then
    rm -rf $VIRTUALENV
fi
if [ ! -d $VIRTUALENV ]; then
    virtualenv --setuptools --prompt="(precs) " $VIRTUALENV
    $VIRTUALENV/bin/pip install --upgrade setuptools==18.3.2
    $VIRTUALENV/bin/pip install --upgrade pip==7.1.2
    $VIRTUALENV/bin/pip install --upgrade pip-tools
fi

$VIRTUALENV/bin/pip-compile requirements.in
$VIRTUALENV/bin/pip-compile requirements-test.in
$VIRTUALENV/bin/pip install $PIP_ARGS -r requirements.txt --exists-action=w
$VIRTUALENV/bin/pip install $PIP_ARGS -r requirements-test.txt --exists-action=w
$VIRTUALENV/bin/pip install --editable .
export PYTHONPATH=`pwd`:$PYTHONPATH
source $VIRTUALENV/bin/activate
