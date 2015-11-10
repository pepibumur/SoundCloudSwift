import Foundation
import WebKit

/// WKWebView subclass that internally interacts with the Oauth2 handler connecting its delegate with the handler
public final class Oauth2WebView: WKWebView, WKNavigationDelegate {
    
    // MARK: - Attributes
    
    /// Oauth2 handler
    private let oauth2: Oauth2
    
    
    // MARK: - Constructor
    
    /**
    Initializes the WebView with the Oauth2 handler and the scope
    
    - parameter oauth2: oauth2 handler
    - parameter scope:  oauth2 scope
    - parameter frame:  WebView frame
    
    - returns: initialized Oauth2WebView
    */
    public init(oauth2: Oauth2, scope: Session.Scope, frame: CGRect) {
        self.oauth2 = oauth2
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        self.navigationDelegate = self
        setup(withScope: scope)
    }
    
    
    // MARK: - Private
    
    private func setup(withScope scope: Session.Scope) {
        self.oauth2.signal.observeNext { (event) -> () in
            switch event {
            case .OpenUrl(let url):
                self.loadRequest(NSURLRequest(URL: url))
            default: break
            }
        }
        self.oauth2.start()
    }
    
    
    // MARK: - WKNavigationDelegate
    
    public func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.URL else { return }
        self.oauth2.validate(url: url)
    }
}