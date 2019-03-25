#
# Be sure to run `pod lib lint Testing01.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RocketChatViewController'
  s.version          = '1.0.0'
  s.summary          = 'RocketChatViewController is a light weight library that allows you to implement a chat on iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Rocket.Chat.ViewController chat component.
                       DESC

  s.homepage         = 'https://github.com/RocketChat/RocketChatViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rocket Chat' => 'ios@rocket.chat' }
  s.source           = { :git => 'https://github.com/RocketChat/RocketChatViewController', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/RocketChat'

  s.ios.deployment_target = '11.0'

  # ViewController
  s.subspec 'ViewController' do |f|
      f.ios.deployment_target = '11.0'
      f.source_files = 'RocketChatViewController/Classes/**/*'
      f.dependency 'DifferenceKit', '~> 1.0'
  end

  # Composer
  s.subspec 'Composer' do |f|
      f.ios.deployment_target = '11.0'
      f.source_files = 'Composer/Classes/**/*'
      f.resources = ['Composer/Assets/*', 'Composer/Sounds/*']
  end

end
