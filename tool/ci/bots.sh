#!/bin/bash

set -x

# Enable core dumps
ulimit -c unlimited

# Remove all existing core dumps
sudo rm -rf /cores/*

# Make directory which contains core dumps writable.
sudo chmod -R +rwx /cores

# Identify where dart SDK resides
DART_BINARY_PATH=$(dart tool/ci/print_dart_path.dart)
DART_SDK_PATH=$(dirname $DART_BINARY_PATH)

# Resign dart and dartvm binaries to give them get-task-allow entitlement.
# Needed for coredump creation to happen successfully.
codesign -vvv -s - -f --entitlements tool/ci/dump.entitlements --xml $DART_SDK_PATH/dart
codesign -vvv -s - -f --entitlements tool/ci/dump.entitlements --xml $DART_SDK_PATH/dartvm

# Check that dart binary still runs.
dart --version

# Run a script that crashes.
dart bin/main.dart

# Check if new core files appeared
ls -al /cores/*

# Dump information from the core (we assume there is just one).
lldb -s tool/ci/dump_threads.lldb --batch $sdkBinPath/dartvm -c /cores/core.*

