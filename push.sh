#!/bin/sh

FIRST_ARGUMENT="$1"
git add .
git commit -m "$FIRST_ARGUMENT"
git push 
