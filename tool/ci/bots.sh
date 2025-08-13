#!/bin/bash

set -x

ulimit -c unlimited
sudo rm -rf /cores/*
sudo chmod -R +rwx /cores

echo Running

which dart

dartPath=$(dart tool/ci/print_dart_path.dart)
sdkBinPath=$(dirname $dartPath)

/usr/libexec/PlistBuddy -c "Add :com.apple.security.get-task-allow bool true" segv.entitlements

codesign -vvv -s - -f --entitlements segv.entitlements --xml $sdkBinPath/dart
codesign -vvv -s - -f --entitlements segv.entitlements --xml $sdkBinPath/dartvm

dart --version

dart bin/main.dart

ls -al /cores/*

lldb -s tool/ci/dump_threads.lldb --batch $sdkBinPath/dartvm -c /cores/core.*

