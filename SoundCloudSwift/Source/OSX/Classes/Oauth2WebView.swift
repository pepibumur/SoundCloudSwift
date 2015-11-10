import Foundation
import WebKit

/// WebView subclass that internally interacts with the Oauth2 handler connecting its delegate with the handler
final public class Oauth2WebView: WebView, WebFrameLoadDelegate {
    
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
        super.init(frame: frame)
        self.frameLoadDelegate = self
        setup(withScope: scope)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    
    private func setup(withScope scope: Session.Scope) {
        self.oauth2.signal.observeNext { (event) -> () in
            switch event {
            case .OpenUrl(let url):
                self.mainFrame.loadRequest(NSURLRequest(URL: url))
            default: break
            }
        }
        self.oauth2.start()
    }
    
    
    // MARK: - WebFrameLoadDelegate
    
    public func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        guard let url = NSURL(string: sender.mainFrameURL)  else { return }
        self.oauth2.validate(url: url)
    }
}