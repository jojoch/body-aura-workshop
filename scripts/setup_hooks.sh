#!/bin/bash

if [ -d .githooks ] && [ -d .git ]; then
    git config core.hooksPath .githooks
    cp -R .githooks .git/hooks
else
    if [ -d .githooks ]; then
        echo "Git hooks not copied. Missing '.git' directory."
    else
        echo "Git hooks not copied. Missing '.githooks' directory."
    fi
fi
