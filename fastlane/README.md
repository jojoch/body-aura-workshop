fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### testflight_deployment
```
fastlane testflight_deployment
```
AppStore build & deploy to Testflight
### deploy
```
fastlane deploy
```
Deploy
### set_build_number
```
fastlane set_build_number
```
Set build number
### validate_env
```
fastlane validate_env
```
Validate environment
### setup_env
```
fastlane setup_env
```
Prepare environment
### cleanup_env
```
fastlane cleanup_env
```
Cleanup environment after build
### install_dependencies
```
fastlane install_dependencies
```
Install CocoaPods
### codesigning
```
fastlane codesigning
```
Fastlane Match codesigning
### build
```
fastlane build
```
Build
### tests
```
fastlane tests
```
Run tests
### pre_codesigning
```
fastlane pre_codesigning
```
Perform any actions before codesigning here
### pre_build
```
fastlane pre_build
```
Perform any actions before build here
### post_build
```
fastlane post_build
```
Perform any actions after build here
### post_deploy
```
fastlane post_deploy
```
Perform any actions after deploy here
### install_templates
```
fastlane install_templates
```
Install file templates

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
