#!/bin/bash

if [ "$1" == "enterprise" ] || [ "$1" == "testflight" ] || [ "$1" == "integrations" ]; then
    [[ $1 = "integrations" ]] && yml="$1.yml" || yml="$1-deployment.yml"

    mkdir -p .github/workflows
    cp "fastlane/sample.env.$1" "fastlane/.env.$1"
    cp ".github/sample-workflows/$yml" ".github/workflows/$yml"

    echo "Make sure that fastlane/.env.$1 is .gitignoired and contains all necessary secrets."
    echo "Also configure .github/workflows/$yml and provide secrets via Github secrets."
else
    echo "Provide a CI type: 'enterprise', 'testflight' or 'integrations'."
fi
