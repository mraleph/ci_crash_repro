#!/bin/bash

set -ex

echo Running

which dart

dart --version


for i in {1..200}
do
  rm -rf .dart_tool
  dart pub get
  dart run build_runner build --delete-conflicting-outputs
done