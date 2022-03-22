# iOS MVVM-C Combine Project template

This repository contains a template for iOS Combine MVVM-C project. It follows our STRV [iOS Coding Guidelines](https://github.com/strvcom/ios/wiki/iOS-Coding-Guidelines).

## Before you start

We're excited that you're starting a new project from scratch and even more so that you're using our STRV template.

This template contains sane defaults that we're used to working with at STRV.

Feel free to modify this template according to your needs. Please keep in mind though that one of the main purposes of this template is to keep projects similar enough - so that they feel familiar to your colleagues.

In particular, please try to minimize changes to the project structure as we'd like to have things organized similarly across all of our projects.

If you feel strongly about changing something, please don't be shy and talk to your leads!

Or even better - open a pull request!

## Project Checklist

**KEEP THIS SECTION IN YOUR README**

This checklist describes the bare minimum that all projects must meet. **Do not update it. If you have any suggestion for an update open a pull request**. 

Go through the [Before you start](####before-you-start) section before you dive into coding. Memorize the [Per feature](####per-feature) list and make sure you take care of every single bullet point before you send a feature for QA to avoid unnecessary bug reports.

#### 1. Before you start
- Review the project specification and design to get familiar with the product and notice any potential challenges or issues
- Follow instructions in the [Setup](##Setup) section
- Decide about the architecture
- Decide with your product manager about the amount of local persistence
- Decide with your product manager if the landscape orientation on iPhone should be enabled. The landscape on iPad must always be enabled
- Set up design style guide
    - All colours have dark mode equivalents
    - Fonts are initialized with font metrics to support dynamic size
- Set up localizations

#### 2. Per feature
- Best practices
    - All native gestures are supported unless they are disabled on purpose (swipe-to-pop, scroll-to-top, ...)
    - Text inputs have correct traits set e.g. content type, keyboard type, auto-correction, capitalization, return key type, etc.
- Layout
    - Expect that every content can grow based on font size
        - No view should have fixed size
    - All text content is displayed in its full length without being truncated (unless on purpose)
    - Feature is usable and properly rendered on all supported devices and in all supported configurations (iPhone SE 1st gen, iPad Pro 12.9-inch, landscape, split screen, ...)
- Dynamic font size
    - All text content grows and shrinks based on the system settings
    - All text content is displayed in its full length without being truncated (unless on purpose)
- VoiceOver
    - User can navigate to all screens and states
    - All actions are available
    - UI elements are iterated in a reasonable order
    - Each UI element has a clear purpose i.e. trait
    - All non-text UI elements have a meaningful content description
    - All text UI elements have a description that matches the displayed text
    - UI elements with non-obvious actions have an accessibility hint
    - Hidden content is invisible for VoiceOver too
- Run audit in Accessibility Inspector before you move a feature to QA
    - Resolve all relevant warnings

## Setup

__This section is applicable only if you want to set up your project for the first time, when you need to rename the project and choose a suitable Github Actions workflow. If you check out a project that was already set up, continue to [Installation](#installation) section.__

This project is a minimal buildable example of Combine MVVM-C project that contains all necessary protocols and extensions for Combine MVVM-C project development.

In order to setup everything at once, just call:
```
make setup PROJECT_NAME={YOUR_PROJECT_NAME} WORKFLOW={testflight|enterprise|integrations}
```
where `PROJECT_NAME` is a name of the project you start working on and `WORKFLOW` is one of the workflow options described in [Fastlane & Github Actions](#fastlane-&-github-actions) section. __WARNING: All whitespaces in `PROJECT_NAME` are replaced with underscores.__

Read through the [Makefile steps](#makefile-steps) section to learn more about single steps of the `make setup`. If any of the step is not applicable for you, please, run the single steps manually.

## Installation

__If you just created a new repo from this template you need to set things up first. Please continue to [Setup](#setup) section.__

Is your project set up? Great! Now you just need to install all dependencies. You can do so by calling:
```
make install
```
You should execute the above command also when you update your Podfile or Gemfile. Besides installing [dependencies](#dependencies), `make install` also sets up [git hooks](#git-hooks).

Read through the [Makefile steps](#makefile-steps) section to learn more about single steps of the `make install`.

## Fastlane & Github Actions

Our build and deployment workflows are based on fastlane. There are shared Fastfiles that you can import from [ios-fastlane](https://github.com/strvcom/ios-fastlane) repository. We use Testflight distribution for client projects whenever possible and Enterprise distribution for research/internal projects - read about how to use shared Fastfiles in the [ios-fastlane](https://github.com/strvcom/ios-fastlane) repository. For local execution of Fastlane commands, use .env files to provide secrets and make sure they are .gitignored. 

You can use Github Actions workflows to automate deployment and run integrations. To use a workflow, simply copy it from the `.github/sample-workflows` to the `.github/workflows` directory and configure repository secrets as described at the beginning of the workflow. Github Secrets are used to store sensitive data like API keys and passwords. Secrets with the `IOS_DEPARTMENT_` prefix are automatically assigned to your repository by your iOS lead. Github Actions are enabled by default on the STRV Github organization and can be triggered as soon as you push a workflow in the `.github/workflows` directory. You might have to enable Actions on client's Github under repository Settings -> Actions.

**Important note:** always use a self-hosted runner on the STRV Github organizations for workflows that require macOS.

## Makefile steps

### Rename project

__Called by: `make setup`__

If you want to rename the project from `BodyAura` to something different (and you probably want that) just run:
```
make rename PROJECT_NAME={YOUR_PROJECT_NAME}
```
Do not forget to run `make install` after renaming, otherwise, your project won't build.

__WARNING: All whitespaces in `PROJECT_NAME` are replaced with underscores.__

### Set up Github Actions

__Called by: `make setup`__

Run the following command to copy .env and workflow files as needed:
```
make setup-ci WORKFLOW={enterprise|testflight|integrations}
```

### Set up bundle

__Called by: `make setup`, `make install`__

We use Gemfile to ensure that you have all dependencies in correct versions. Run the following command to install all dependencies to the project directory.
```
make install-bundle
```

### Install dependencies

__Called by: `make setup`, `make install`__

Once you set up the bundle and you have all necessary tools, you can install [CocoaPods](https://cocoapods.org) dependencies by executing:
```
make install-dependencies
```

### Set up Git hooks

__Called by: `make setup`, `make install`__

Formatting your code with SwiftFormat is typically done in a build phase. Unfortunately, it often leads to inconsistencies between file versions in Xcode and on the disk, plus, if a file is reformatted you aren't able to undo changes with `CMD+Z`. That's why the formatting is done in a pre-commit hook. In order to setup this hook, do not forget to run:
```
make setup-hooks
```

## Xcode templates

The repository also contains 3 Xcode templates for convenient creation of Combine MVVM-C view controller scene, navigation controller scene and tab bar controller scene. You can find the templates in `fastlane/templates`

Follow these 3 simple steps to import the templates to your Xcode
1. Install [Fastlane](https://github.com/fastlane/fastlane)
2. Open Terminal and go to the project root folder
3. Run `fastlane install_templates`
4. Restart Xcode

That's it. Now if you open your Xcode, go to `File -> New -> File...` and scroll down a bit, you will see a section called `STRV Templates` with 3 template files.

### TabBarController template

This template serves for a tab bar controller scene creation. It is done in 3 steps.

1. Select `TabBarController` template from the add new file dialog.
2. Specify a superclass of your tab bar controller and a name of coordinator that will be interconnected with the tab bar controller.
3. Enter a name of your tab bar controller.

Xcode will create `{TAB_BAR_CONTROLLER_NAME}.swift`, `{COORDINATOR_NAME}.swift` and `{COORDINATOR_NAME}ing.swift` for you.

### NavigationController template

This template serves for a navigation controller scene creation. It is done in 3 steps.

1. Select `NavigationController` template from the add new file dialog.
2. Specify a superclass of your navigation controller and a name of coordinator that will be interconnected with the navigation controller.
3. Enter a name of your navigation controller.

Xcode will create `{NAVIGATION_CONTROLLER_NAME}.swift`, `{COORDINATOR_NAME}.swift` and `{COORDINATOR_NAME}ing.swift` for you.

### ViewController template

This template serves for a regular view controller scene creation. It is done in 3 steps.

1. Select `ViewController` template from the add new file dialog.
2. Specify a superclass of your view controller, data type of a corresponding coordinator and the corresponding view model name.
3. Enter a name of your view controller.

Xcode will create `{VIEW_CONTROLLER_NAME}.swift`, `{VIEW_CONTROLLER_NAME}.storyboard`, `{VIEW_MODEL_NAME}.swift`
