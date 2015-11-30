import Foundation
import ReactiveCocoa
import Genome
import Alamofire

public struct SoundCloud {
    
    // MARK: - Me
    
    /**
    Gets user profile.
    
    - parameter session: User session.
    
    - returns: Signal producer that executes the action.
    */
    public static func getMe(session: Session) -> SignalProducer<User, RequestError> {
        return get("me", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<User, RequestError> in
                do {
                    let user = try User.mappedInstance(input as! JSON)
                    return SignalProducer(value: user)
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    
    // MARK: - Connections
    
    /**
    Gets a given connection with the provided identifier.
    
    - parameter id: Connection identifier.
    
    - returns: Signal producer that executes the action.
    */
    public static func getConnection(id: String)(session: Session) -> SignalProducer<Connection, RequestError> {
        return get("me/connections/\(id)", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<Connection, RequestError> in
                do {
                    return try SignalProducer(value: Connection.mappedInstance(input as! JSON))
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    /**
     Gets the user's connections.
     
     - parameter session: User session.
     
     - returns: Signal producer that executes the action.
     */
    public static func getConnections(session: Session) -> SignalProducer<[Connection], RequestError> {
        return get("me/connections", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<[Connection], RequestError> in
                do {
                    guard let connections = input as? [AnyObject] else { return SignalProducer(error: .InvalidType) }
                    return try SignalProducer(value: connections.map { try Connection.mappedInstance($0 as! JSON) })
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    /**
     Creates a new connection for the provided service and redirect url.
     
     - parameter service:     Connection service
     - parameter redirectUrl: Connection redirect url
     
     - returns: Signal producer that executes the action. The returned value is the authorize url that has to be opened in the browser in order to authorize the connection.
     */
    public static func createConnection(service: String, redirectUrl: String)(session: Session) -> SignalProducer<String, RequestError> {
        let parameters = ["service": service, "redirect_url": redirectUrl]
        return post("me/connections", parameters: parameters, session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<String, RequestError> in
                guard let json = input as? JSON else { return SignalProducer(error: .InvalidType) }
                guard let redirectUri = json["authorize_url"] as? String else { return SignalProducer(error: .InvalidType) }
                return SignalProducer(value: redirectUri)
            })
    }
    
    public static func connection(id: String)(session: Session) -> SignalProducer<Connection, RequestError> {
        return SignalProducer.empty
    }
    
    public static func activities(session: Session) -> SignalProducer<Connection, RequestError> {
        return SignalProducer.empty
    }
    
    public static func apps(session: Session) -> SignalProducer<Application, RequestError> {
        return SignalProducer.empty
    }
}


// MARK: - Private

private func get(path: String, session: Session) -> SignalProducer<AnyObject, RequestError> {
    let url: NSURL = NSURL(string: "https://api.soundcloud.com")!.URLByAppendingPathComponent(path)
    return SignalProducer { (observer, disposable) in
        Alamofire.request(.GET, url.absoluteString, parameters: params([:], withToken: session.accessToken), encoding: .URL, headers: nil)
            .responseJSON { (response) -> Void in
                let result = response.result
                if let error = result.error {
                    observer.sendFailed(RequestError.HTTPError(error))
                }
                else if let value  = result.value {
                    observer.sendNext(value)
                    observer.sendCompleted()
                }
                else {
                    observer.sendCompleted()
                }
            }
    }
}

private func post(path: String, parameters: [String: AnyObject], session: Session) -> SignalProducer<AnyObject, RequestError> {
    return SignalProducer { (observer, disposable) in
        let url: NSURL = NSURL(string: "https://api.soundcloud.com")!.URLByAppendingPathComponent(path)
        Alamofire.request(.POST, url, parameters: params(parameters, withToken: session.accessToken), encoding: ParameterEncoding.URL).responseJSON(completionHandler: { (response) -> Void in
            let result = response.result
            if let error = result.error {
                observer.sendFailed(RequestError.HTTPError(error))
            }
            else if let value  = result.value {
                observer.sendNext(value)
                observer.sendCompleted()
            }
            else {
                observer.sendCompleted()
            }
        })
    }
}

private func params(parameters: [String: AnyObject], withToken token: String) -> [String: AnyObject] {
    var parametersWithToken: [String: AnyObject] = parameters
    parametersWithToken["oauth_token"] = token
    print(parametersWithToken)
    return parametersWithToken
}


