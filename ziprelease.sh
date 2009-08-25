#!/bin/sh

version=1.1
zipfile=../releases/mark-logic-xfaqtor-$version.zip
exclude="$zipfile ziprelease.sh *.svn*"

zip -r $zipfile * -x $exclude
