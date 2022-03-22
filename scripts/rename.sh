#!/bin/bash

original=STRV_template
updated=`echo $1 | sed 's/ /_/g'`

find . -type f -not -path "./.git*" -not -path "./Pods*" -not -path "./scripts*" -not -path "./vendor*" -not -path "./.bundle*" -print0 | while IFS= read -r -d '' file; do
    # First, copy the file with its permissions
    cp "$file" "$file.tmp"
    sed "s/$original/$updated/g" "$file" 2> /dev/null 1> "$file.tmp"
    rm "$file"
    mv "$file.tmp" "$file"
done

find . -type d -name "*$original*" -print0 | while IFS= read -r -d '' file; do
    new=`echo "$file" | sed "s/$original/$updated/g"`
    mv "$file" "$new"
done

find . -type f -name "*$original*" -print0 | while IFS= read -r -d '' file; do
    new=`echo $file | sed "s/$original/$updated/g"`
    mv "$file" "$new"
done
