#!/bin/bash

echo "Example Change $@" >>example_$1.txt
git add example_$1.txt
git commit -m "Example Change $1 ($2)"
