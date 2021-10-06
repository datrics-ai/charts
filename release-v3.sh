#!/bin/sh

cd charts
helm3 package pipeline2
helm3 package api
helm3 package previewer
helm3 package app

cd ..
helm3 repo index .

# tag it
git add -A
git commit -m "Release charts"
git push