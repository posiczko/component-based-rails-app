#!/bin/bash
trap "exit" ERR

echo "       Copy deploy files into place"
rm -rf deploy
mkdir deploy
cp -R web_container/ deploy
cp -R components deploy
rm -rf deploy/tmp/*

echo "       Fix components directory reference"
gsed -i s|"\.\./components|"components|g deploy/Gemfile
gsed -i s|remote: \.\./components|remote: \.\/components|g \
    deploy/Gemfile.lock

echo "       Uploading application...."
