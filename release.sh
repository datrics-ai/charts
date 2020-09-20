#!/bin/sh

cd charts
helm package pipeline2

cd ..
helm repo index charts/
mv charts/index.yaml .

# tag it
git add -A
git commit -m "Release charts"
git push