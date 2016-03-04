![image](https://github.com/pepibumur/SoundCloudSwift/blob/master/Assets/header.png?raw=true)

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/pepibumur/SoundCloudSwift.svg?branch=feature%2Fmodels)](https://travis-ci.org/pepibumur/SoundCloudSwift)
![platforms](https://img.shields.io/badge/platform-ios|osx|watchos-lightgrey.svg?style=flat)
[![CocoaPods](https://img.shields.io/cocoapods/v/SoundCloudSwift.svg)]()

SoundCloud client written on Swift to integrate it easily with your apps.

## Features
- Fluent interface based on Models
- Reactive API with ReactiveCocoa 4.0
- User session management (Oauth handling and session persistence)
- Music player
- Swift 2.0 features (generics, enums, ...)
- 100% tested
- Command Line tool

## Dependencies
- [Alamofire](https://github.com/Alamofire/Alamofire): Alamofire is an HTTP networking library written in Swift.
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa): ReactiveCocoa (RAC) is a Cocoa framework inspired by Functional Reactive Programming. It provides APIs for composing and transforming streams of values over time.
- [Genome](https://github.com/LoganWright/Genome): A simple, type safe, failure driven mapping library for serializing JSON to models in Swift 2.0 (Supports Linux)
- [Keychain-Swift](https://github.com/marketplacer/keychain-swift): Helper functions for storing text in Keychain for iOS, OS X, tvOS and WatchOS
- [Quick & Nimble](https://github.com/quick): The Swift (and Objective-C) testing and matching frameworks.
- [Mockingjay](https://github.com/kylef/Mockingjay): An elegant library for stubbing HTTP requests in Swift, allowing you to stub any HTTP/HTTPS using NSURLConnection or NSURLSession. That includes any request made from libraries such as Alamofire and AFNetworking.

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
github "pepibumur/SoundCloudSwift"
```

### Cocoapods

You can also integrate SoundCloudSwift using CocoaPods. Just add the following line to your `Podfile`:

```ruby
pod "SoundCloudSwift", :git => "https://github.com/pepibumur/SoundCloudSwift.git"
```

And execute `pod install`. Remember to open the project using the file `.xcworkspace`


## Wiki

- [Authentication](Wiki/authentication.md)

## Documentation
- SoundCloud API: [Link](https://developers.soundcloud.com/docs/api/guide)
- SoundCloudAPI (Objective-C client): [Link](https://github.com/soundcloud/CocoaSoundCloudAPI)

## Credits

SoundCloudSwift is owned and maintained by the [@pepibumur](https://github.com/pepibumur).

## Security Disclosure

If you believe you have identified a security vulnerability with SoundCloudSwift, you should report it as soon as possible via email to pepibumur@gmail.com. Please do not post it to a public issue tracker.

## License

SoundCloudSwift is released under the MIT license. See LICENSE for details.
