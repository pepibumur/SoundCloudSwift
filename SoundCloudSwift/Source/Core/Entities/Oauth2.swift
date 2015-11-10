import Foundation
import ReactiveCocoa
import Alamofire


/**
 *  Internal constants
 */
private struct Constants {
    static let urlConnect: String = "https://soundcloud.com/connect/"
    static let urlToken: String = "https://api.soundcloud.com/oauth2/token/"
}

/**
 *  Entity for handling the Oauth2 flow with the SoundCloud API
 */
public class Oauth2 {
    
    /**
     It represents the current flow status
     
     - Idle:       The Oauth process hasn't started yet
     - InProgress: The Oauth process is in progress
     - Completed:  The Oauth process is completed
     - Failed:     The Oauth process did fail
     */
    private enum Status {
        case Idle
        case InProgress
        case Completed
        case Failed
    }
    
    /**
     Oauth events sent through the signal
     
     - OpenUrl:    open the provided url in a web browser in order to start the Oauth flow
     - NewSession: authentication successful, new session provided
     */
    public enum Event {
        case OpenUrl(NSURL)
        case NewSession(Session)
    }
    
    
    // MARK: - Attributes
    
    /// Signal with the Oauth login events
    public let signal: Signal<Oauth2.Event, OauthError>
    
    /// Oauth configuration
    private let config: Oauth2Config
    
    /// Observer to send the Oauth login events
    private let observer: Observer<Oauth2.Event, OauthError>
    
    /// Private state to correlate with the redirect url state param
    private let state: String = Randomizer.randomStringWithLength(8)
    
    /// It represents the Oauth process status
    private var status: Status = .Idle

    /// It represents the API access scope
    private let scope: Session.Scope
    
    // MARK: - Constructor
    
    /**
    Default OauthConfig constructor
    
    - parameter config: Oauth configuration
    - parameter scope: Scope
    
    - returns: initialized OauthConfig
    */
    public init(config: Oauth2Config, scope: Session.Scope) {
        self.config = config
        self.scope = scope
       (self.signal, self.observer) = Signal<Event, OauthError>.pipe()
    }
    
    
    // MARK: - Public
    
    
    /**
    Starts the Oauth2 flow
    
    - parameter scope: API scope
    */
    public func start() {
        if self.status != .Idle {
            failed(.StateInconsistence)
            return
        }
        self.status = .InProgress
        let authUrl = authorizationUrl(withScope: scope)
        if let error = authUrl.error {
            failed(error)
            return
        }
        else if let url = authUrl.url {
            observer.sendNext(.OpenUrl(url))
            return
        }
        else {
            failed(.Unknown)
        }
    }
    
    /**
     Validates an URL and check if it's the redirect URL from the Oauth flow. It'll extract the authorization code from there and will request the access token to the API
     
     - parameter url: web browser redirect URL
     */
    public func validate(url url: NSURL) {
        validateParameters(fromUrl: url, redirectUri: config.redirectUri, sourceState: state)
            .flatMap(.Latest, transform: authenticate(config)(scope: scope))
            .on(terminated: { [weak self] () -> () in
                self?.status = .Completed
            })
            .start(observer)
    }
    
    
    // MARK: - Private
    
    /**
    Reports an error to the signal and updates the status
    
    - parameter error: error to be reported
    */
    private func failed(error: OauthError) {
        self.status = .Failed
        observer.sendFailed(error)
    }
    
    /**
    Returns the authorization URL for the provided scope
    
    - parameter scope: access scope
    
    - returns: tuple with url and error (in case of any generating the url)
    */
    private func authorizationUrl(withScope scope: Session.Scope) -> (error: OauthError?, url: NSURL?) {
        var params: [String: String] = [:]
        params["client_id"] = config.clientId
        params["redirect_uri"] = config.redirectUri
        params["response_type"] = "code"
        params["state"] = state
        params["display"] = "popup"
        let (request, error) = Alamofire.ParameterEncoding.URL.encode(NSURLRequest(URL: NSURL(string: Constants.urlConnect)!), parameters: params)
        if let error = error {
            return (OauthError.AuthorizationUrlGeneration(error), nil)
        }
        else {
            return (nil, request.URL)
        }
    }
}

/**
 Validates the redirect url parameters
 
 - parameter url:         url to be validated
 - parameter redirectUri: redirect url
 - parameter sourceState: source state that was sent when the Oauth process was started
 
 - returns: SignalProducer that executes the action
 */
func validateParameters(fromUrl url: NSURL, redirectUri: String, sourceState: String) -> SignalProducer<String, OauthError> {
    return SignalProducer { (observer, disposable) in
        if !url.absoluteString.containsString(redirectUri) {
            observer.sendCompleted()
            return
        }
        guard let parameters = url.parseQuery() as? [String: String] else {
            observer.sendFailed(.InvalidRedirectUrl)
            return
        }
        guard let code: String = parameters["code"] else {
            observer.sendFailed(.MissingParameter)
            return
        }
        guard let state: String = parameters["state"] else {
            observer.sendFailed(.MissingParameter)
            return
        }
        if sourceState != state {
            observer.sendFailed(.StateMismatch)
            return
        }
        observer.sendNext(code)
        observer.sendCompleted()
    }
}

/**
 Authenticates against the Soundcloud API using the provided config and scope
 
 - parameter config: API client configuration
 - parameter scope: Access scope
 
 - returns: function that given a code returns a SignalProducer that executes the action
 */
func authenticate(config: Oauth2Config)(scope: Session.Scope)(withCode code: String) -> SignalProducer<Oauth2.Event, OauthError> {
    return SignalProducer { (observer, disposable) in
        var parameters: [String: AnyObject] = [:]
        parameters["client_id"] = config.clientId
        parameters["client_secret"] = config.clientSecret
        parameters["redirect_uri"] = config.redirectUri
        parameters["grant_type"] = "authorization_code"
        parameters["code"] = code
        Alamofire.request(.POST, Constants.urlToken, parameters: parameters, encoding: ParameterEncoding.URL).responseJSON(completionHandler: { (response) -> Void in
            if let error = response.result.error {
                observer.sendFailed(.APIError(error))
                return
            }
            guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                observer.sendFailed(.InvalidResponse)
                return
            }
            observer.sendNext(Oauth2.Event.NewSession(Session(dictionary: jsonResponse)))
            observer.sendCompleted()
        })
    }
}