# Authentication
SoundCloudSwift provides tools for authentication that you can use within your apps.

### iOS & OSX

1. Create an `Oauth2` object *(handler)* passing the `Oauth2Config` which includes *(client id, client secret and redirect uri)* provided by the API.

```swift
let oauth2: Oauth2 = Oauth2(config: Oauth2Config(clientId: clientId, clientSecret: clientSecret, redirectUri: redirect), scope: .All)
```

2. Subscribe to the Oauth2 signal to listen for status changes during the Oauth2 flow:

```swift
oauth2.signal.observeNext { (next) -> () in
  switch next {
    case .OpenUrl(let url): // Open url
    case .NewSession(let session): // Authentication completed
  }
  // Status events
}
```
Notice the kind of events that are sent:
- **OpenUrl**: When this event is sent you have to open the provided link in your webview.
- **NewSession**: When this event is received we have a new user session that we can use to authenticate API requests.

2. Connect your webview with `Oauth2` sending redirect URLs from the browser:
```swift
oauth2.validate(url: newUrl)
```

3. Start the Oauth2 flow with `oauth2.start()`

#### Oauth2WebView and Oauth2WebViewController 

If you're going to use the native Webkit we provide you with a class, `Oauth2WebView` that automatizes the process. This class is initialized with the Oauth2 object and internally connects the Webview delegate with that object.

Your only responsibility in that case is listening to next events. *That's all!*

```swift
let viewController: Oauth2WebViewController = Oauth2WebViewController(oauth2: oauth2, scope: .All)
oauth2.signal.observeNext { (next) -> () in
    print(next)
}
```



### tvOS & watchOS

These systems don't support Webview, thus we cannot execute the authentication flow in these platforms. What we can do instead if sharing the authentication information from an iOS device or from OSX.

**watchOS**
- [WatchKit: Best practices sharing data between your watch an iOS app](http://www.kristinathai.com/watchkit-best-practices-for-sharing-data-between-your-watch-and-ios-app/)
- [Watch 2 transition guide](https://developer.apple.com/library/watchos/documentation/General/Conceptual/AppleWatch2TransitionGuide/UpdatetheAppCode.html)

**tvOS**

Apple doesn't provide any Connectivity framework to share data between iOS and tvOS. To solve this problem you can go to HTTP/TCP/Bluetooth custom solutions that you'll have to implement on your own

> We thought about implementing a custom sharing component for SoundCloudSwift but due to the fact that tvOS is in its early versions we preferred to wait for next version to see Apple's strategy around this topic.

### Recommended articles
- [Oauth Authentication on tvOS](http://stephenradford.me/oauth-login-on-tvos/)
