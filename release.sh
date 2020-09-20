#!/bin/sh

cd charts
helm package pipeline2

cd ..
helm repo index .

# tag it
git add -A
git commit -m "Release charts"
git push