#!/bin/sh
set -e
PATH="/usr/local/bin:$PATH"
dir="`git rev-parse --git-dir`"
trap 'rm -f "$dir/$$.tags"' EXIT
ctags -R -f"$dir/$$.tags" --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths) 
mv "$dir/$$.tags" "$dir/../tags"
