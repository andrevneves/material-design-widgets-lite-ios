#
#  Be sure to run `pod spec lint material-design-widgets-lite-ios.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "MaterialDesignWidgets"
  #spec.version      = "0.1.2"
  spec.version      = "0.0.9"
  spec.summary      = "Material design styled buttons, vertically arranged buttons, activity loader and loading button."
  spec.homepage     = "https://github.com/andrevneves/material-design-widgets-lite-ios"
  spec.license      = "MIT"
  spec.author       = "Andre Vicente Neves"
  spec.platform     = :ios
  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/andrevneves/material-design-widgets-lite-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "MaterialDesignWidgets", "MaterialDesignWidgets/**/*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


end
