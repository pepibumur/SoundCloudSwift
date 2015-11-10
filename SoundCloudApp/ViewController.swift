import UIKit
import SoundCloudSwift

class ViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupAppearance()
        setupNavigation()
    }
    
    private func setupAppearance() {
        self.title = "SoundCloudSwift"
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: "userDidSelectLogin:")
    }
    
    
    // MARK: - Actions
    
    func userDidSelectLogin(sender: AnyObject!) {
        let clientId: String = "da4d86aabbcf228c9d69d96729241962"
        let clientSecret: String = "571dbd5ca1dda6de40ddfe0c56b7118c"
        let redirect: String = "soundcloudswift://soundcloud/callback"
        let oauth2: Oauth2 = Oauth2(config: Oauth2Config(clientId: clientId, clientSecret: clientSecret, redirectUri: redirect), scope: .All)
        let viewController: Oauth2WebViewController = Oauth2WebViewController(oauth2: oauth2, scope: .All)
        self.navigationController?.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        oauth2.signal.observeNext { (next) -> () in
            print(next)
        }
    }
}

