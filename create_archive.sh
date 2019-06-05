#!/bin/sh
rm -rf temp/target temp/container temp/pom.xml
tar cfz dockerimage.tgz -C temp .

