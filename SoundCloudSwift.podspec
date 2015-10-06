#
# Be sure to run `pod lib lint SoundCloudSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SoundCloudSwift"
  s.version          = "0.0.1"
  s.summary          = "SoundCloud client implemented on Swift"
  s.description      = <<-DESC
  SoundCloudSwift is a Swift library to interact with SoundCloud API.
  It offers session management, API interaction and music playing with a fresh Swift fluent interface
  taking advantage of  Swift features
                       DESC
  s.homepage         = "https://github.com/SugarTeam/SoundCloudSwift"
  s.license          = 'MIT'
  s.author           = { "Pepi" => "pepibumur@gmail.com", "David" => "david@psychosity.net" }
  s.source           = { :git => "https://github.com/SugarTeam/SoundCloudSwift.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SoundCloudSwift/Source/**/*'
  s.resource_bundles = {
    'SoundCloudSwift' => ['SoundCloudSwift/Assets/*.png']
  }
  s.dependency 'Alamofire', '3.0.0-beta.3'
  s.dependency 'Genome', '1.0'
  s.dependency 'ReactiveCocoa', '4.0.2-alpha-1'
  s.dependency 'Runes', '3.0.0'
  s.dependency 'KeychainSwift'
end 

