# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

inhibit_all_warnings!

source 'https://github.com/lilizing/PrivatePods.git'
source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'Leo' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  pod 'ReactiveCocoa',      '2.4.7'
  pod 'Masonry',            '1.0.2'
  
  target 'LeoCommonObjc'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            #            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            #            config.build_settings['SWIFT_VERSION'] = '3.2'
            config.build_settings['SDKROOT'] = 'iphoneos'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
