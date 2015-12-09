Pod::Spec.new do |s|
  s.name             = "SoundCloudSwift"
  s.version          = "0.0.1"
  s.summary          = "SoundCloud client implemented on Swift"
  s.description      = <<-DESC
  SoundCloudSwift is a Swift library to interact with SoundCloud API.
  It offers session management, API interaction and music playing with a fresh Swift fluent interface
  taking advantage of  Swift features
                       DESC
  s.homepage         = "https://github.com/pepibumur/SoundCloudSwift"
  s.license          = 'MIT'
  s.author           = { "Pepi" => "pepibumur@gmail.com" }
  s.source           = { :git => "https://github.com/pepibumur/SoundCloudSwift.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  # Deployment targets
  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'

  # Source files
  s.source_files = 'SoundCloudSwift/Source/Core/**/*'
  s.ios.source_files = 'SoundCloudSwift/Source/iOS/**/*'
  s.osx.source_files = 'SoundCloudSwift/Source/OSX/**/*'

  # Frameworks
  s.ios.frameworks = 'WebKit'
  s.osx.frameworks = 'WebKit'

  # Dependencies
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'Genome', '~> 1.0'
  s.dependency 'ReactiveCocoa', '4.0.4-alpha-4'
  s.dependency 'KeychainSwift', '~> 3.0'
end
