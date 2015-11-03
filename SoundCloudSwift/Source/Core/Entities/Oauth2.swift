import Foundation
import ReactiveCocoa
import Alamofire

/**
 *  Entity for handling the Oauth2 flow with the SoundCloud API
 */
public struct Oauth2 {
    
    /**
     *  Internal constants
     */
    private struct Constants {
        static let urlConnect: String = "https://soundcloud.com/connect"
        static let urlToken: String = "https://soundcloud.com/oauth2/token"
    }
    
    /**
     Oauth events sent through the signal
     
     - OpenUrl:    open the provided url in a web browser in order to start the Oauth flow
     - NewSession: authentication successful, new session provided
     */
    public enum OauthEvent {
        case OpenUrl(NSURL)
        case NewSession(Session)
    }
    
    public enum Scope: String {
        case All = "*"
    }
    
    
    // MARK: - Attributes
    
    /// Signal with the Oauth login events
    public let signal: Signal<OauthEvent, OauthError>
    
    /// Oauth configuration
    private let config: OauthConfig
    
    /// Observer to send the Oauth login events
    private let observer: Observer<OauthEvent, OauthError>
    
    /// Private state to correlate with the redirect url state param
    private let state: String = Randomizer.randomStringWithLength(8)
    
    
    // MARK: - Constructor
    
    /**
    Default OauthConfig constructor
    
    - parameter config: Oauth configuration
    
    - returns: initialized OauthConfig
    */
    init(config: OauthConfig) {
        self.config = config
       (self.signal, self.observer) = Signal<OauthEvent, OauthError>.pipe()
    }
    
    
    // MARK: - Public
    
    
    /**
    Starts the Oauth2 flow
    
    - parameter scope: API scope
    */
    public func start(withScope scope: Scope) {
        let authUrl = authorizationUrl(withScope: scope)
        if let error = authUrl.error {
            observer.sendFailed(error)
            return
        }
        else if let url = authUrl.url {
            observer.sendNext(.OpenUrl(url))
            return
        }
        else {
            observer.sendFailed(.Unknown)
        }
    }
    
    /**
     Validates an URL and check if it's the redirect URL from the Oauth flow. It'll extract the authorization code from there and will request the access token to the API
     
     - parameter url: web browser redirect URL
     */
    public func validate(url url: NSURL) {
        
        // Check scheme
        // Check state
        // Get code
        // Request token
        
        
    }
    
    
    // MARK: - Private
    
    /**
    Returns the authorization URL for the provided scope
    
    - parameter scope: access scope
    
    - returns: tuple with url and error (in case of any generating the url)
    */
    private func authorizationUrl(withScope scope: Scope) -> (error: OauthError?, url: NSURL?) {
        var params: [String: String] = [:]
        params["client_id"] = config.clientId
        params["redirect_uri"] = config.redirectUri
        params["response_type"] = "code"
        params["scope"] = scope.rawValue
        params["display"] = "popup"
        params["state"] = state
        let (request, error) = Alamofire.ParameterEncoding.URL.encode(NSURLRequest(URL: NSURL(string: Constants.urlConnect)!), parameters: params)
        if let error = error {
            return (OauthError.AuthorizationUrlGeneration(error), nil)
        }
        else {
            return (nil, request.URL)
        }
    }
}