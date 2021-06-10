#
# Be sure to run `pod lib lint WaterfallKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
# @see https://gsl201600.github.io/2019/10/16/iOS%E5%8F%91%E5%B8%83CocoaPods%E7%A7%81%E6%9C%89%E5%BA%93/
#

Pod::Spec.new do |s|
  s.name             = 'WaterfallKit'
  s.version          = '0.0.3'
  s.summary          = '自定义UICollectionViewLayout布局'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        多种UICollectionViewLayout布局方式
                       DESC

  s.homepage         = 'https://github.com/woodjobber/WaterfallKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'woodjobber' => 'woodjobber@outlook.com' }
  s.source           = { :git => 'https://github.com/woodjobber/WaterfallKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.platform     = :ios, '10.0'
  
  s.source_files = 'WaterfallKit/Classes/**/*'
  
  s.swift_version = "5.0"
  
  s.requires_arc = true
  
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES'}
  
  #s.static_framework = true
  
  # s.resource_bundles = {
  #   'WaterfallKit' => ['WaterfallKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
