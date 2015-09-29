![image](https://github.com/SugarTeam/SoundCloudSwift/blob/master/Assets/header.png?raw=true)

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

SoundCloud client written on Swift to integrate it easily with your apps.
Actively developed by [@pepibumur](https://github.com/pepibumur) & [@dcvz](https://github.com/dcvz)

## Features
- Fluent interface based on Models `User.tasks(client: client)
- Reactive API with ReactiveCocoa 4.0
- User session management (Oauth handling and session persistence)
- Music player
- Swift 2.0 features (generics, enums, ...)
- 100% tested
- Command Line tool

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / watchOS 2
- XCode 7.0+

## Communication
- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/soundcloudswift)
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/soundcloudswift).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SoundCloudSwift into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "SugarTeam/SoundCloudSwift"
```

### Cocoapods

You can also integrate SoundCloudSwift using CocoaPods. Just add the following line to your `Podfile`:

```ruby
pod "SoundCloudSwift", :git => "https://github.com/SugarTeam/SoundCloudSwift.git"
```

And execute `pod install`. Remember to open the project using the file `.xcworkspace`


## Documentation
- SoundCloud API: [Link](https://developers.soundcloud.com/docs/api/guide)
- SoundCloudAPI (Objective-C client): [Link](https://github.com/soundcloud/CocoaSoundCloudAPI)

## Credits

SoundCloudSwift is owned and maintained by the [@sugarteam](https://github.com/SugarTeam).

## Security Disclosure

If you believe you have identified a security vulnerability with SoundCloudSwift, you should report it as soon as possible via email to pepibumur@gmail.com. Please do not post it to a public issue tracker.

## License

SoundCloudSwift is released under the MIT license. See LICENSE for details.
