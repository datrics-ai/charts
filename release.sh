#!/bin/sh

cd charts
helm package pipeline2
helm package api
helm package previewer
helm package app

cd ..
helm repo index .

# tag it
git add -A
git commit -m "Release charts"
git push