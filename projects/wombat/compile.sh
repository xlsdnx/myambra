#!/bin/bash

BUILDDIR="/build"

rm $BUILDDIR/*

echo Compiling

cd /src

mvn -Dmaven.test.skip=true clean package

cp target/*.war $BUILDDIR
cp /scripts/* $BUILDDIR

grep ^version= target/maven-archiver/pom.properties | head -1 | sed 's/^version=//' > $BUILDDIR/version.txt

rm -rf target
