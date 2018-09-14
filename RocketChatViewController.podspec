#
# Be sure to run `pod lib lint Testing01.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RocketChatViewController'
  s.version          = '0.1.0'
  s.summary          = 'RocketChatViewController is a light weight library that allows you to implement a chat on iOS.'
 
  s.dependency 'DifferenceKit', '~> 0.5.3'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RocketChat/RocketChatViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rocket Chat' => 'ofilipealvarenga@gmail.com' }
  s.source           = { :git => 'https://github.com/RocketChat/RocketChatViewController', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/RocketChat'

  s.ios.deployment_target = '10.0'

  s.source_files = 'RocketChatViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RocketChatViewController' => ['Example/RocketChatViewController/RocketChatViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Example/RocketChatViewController/RocketChatViewController/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
