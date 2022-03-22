#!/usr/bin/env bash
set -eo pipefail

# Default the folder name to "Project Name".
folderName="STRV Combine Templates"
installDirectory=~/Library/Developer/Xcode/Templates/File\ Templates/"$folderName"

if [[ $1 == "install" ]]; then
# Create the install directory if it does not exist.
if [ ! -d "$installDirectory" ]; then
mkdir -p "$installDirectory"
fi

echo $PWD
# Copy all of the xctemplate folders into the install directory.
cp -r ./templates/*.xctemplate "$installDirectory"
fi

if [[ $1 == "unistall" ]]; then
rm -rf "$installDirectory"
fi
