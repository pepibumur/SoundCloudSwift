import Foundation
import UIKit

public final class Oauth2WebViewController: UIViewController {
    
    // MARK: - Attributes
    
    /// Oauth2WebView responsible of the Oauth2 process
    private var oauth2WebView: Oauth2WebView!
    
    
    // MARK: - Init
    
    /**
    Initializes the Oauth2 Web View Controller
    
    - parameter oauth2: Oauth2 entity
    - parameter scope:  Acces scope
    
    - returns: initialize Oauth2WebViewController
    */
    public init(oauth2: Oauth2, scope: Session.Scope) {
        super.init(nibName: nil, bundle: nil)
        self.oauth2WebView = Oauth2WebView(oauth2: oauth2, scope: scope, frame: CGRectZero)
        self.title = "SoundCloud login"
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.oauth2WebView)
        self.oauth2WebView.frame = self.view.bounds
        setupNavigation()
    }
    
    
    // MARK: - Private
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "userDidSelectDone:")
    }
    
    
    // MARK: - Actions
    
    func userDidSelectDone(sender: AnyObject!) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}