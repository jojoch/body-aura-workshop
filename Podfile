source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

abstract_target 'defaults' do

  pod 'SwiftLint', '~> 0.42.0'
  pod 'SwiftFormat/CLI', '~> 0.47.0'
  pod 'R.swift'

  # App

  target 'BodyAura'

end

# Workaround for Xcode 12 to set deployment targets greater than or equal to iOS 9.0
post_install do |installer|
   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].split('.')[0].to_i < 9
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
       end
     end
   end
end
