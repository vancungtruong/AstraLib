#
# Be sure to run `pod lib lint AstraLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AstraLib'
  s.version          = '1.0.0'
  s.summary          = 'A short description of AstraLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Cung Truong/AstraLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cung Truong' => 'vancungtruong@gmail.com' }
  s.source           = { :git => 'https://github.com/Cung Truong/AstraLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'AstraLib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AstraLib' => ['AstraLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SwiftyStoreKit', '~> 0.16.1'
   s.dependency 'Adjust', '~> 4.29.7'
   s.dependency 'FBSDKCoreKit', '~> 12.3.2'
   s.dependency 'Firebase/Analytics', '~> 8.12.0'
end
