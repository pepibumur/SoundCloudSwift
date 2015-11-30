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
    public static func getConnection(id: Int)(session: Session) -> SignalProducer<Connection, RequestError> {
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
     
     - parameter service:     Connection service.
     - parameter redirectUrl: Connection redirect url.
     - parameter session:       User session.
     
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
    
    
    // MARK: - Apps
    
    /**
     Gets user apps.
     
     - parameter session: User session.
     
     - returns: Signal producer that executes the action.
     */
    public static func getApps(session: Session) -> SignalProducer<[Application], RequestError> {
        return get("apps", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<[Application], RequestError> in
                do {
                    guard let connections = input as? [AnyObject] else { return SignalProducer(error: .InvalidType) }
                    return try SignalProducer(value: connections.map { try Application.mappedInstance($0 as! JSON) })
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    
    // MARK: - Comments
    
    /**
    Get a given comment.
    
    - parameter id: resource identifier.
    - parameter session: User session.

    - returns: Signal producer that executes the action.
    */
    public static func getComment(id: Int)(session: Session) -> SignalProducer<Comment, RequestError> {
        return get("comments/\(id)", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<Comment, RequestError> in
                do {
                    return try SignalProducer(value: Comment.mappedInstance(input as! JSON))
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    
    // MARK: - Groups
    
    public static func getGroup(groupId: Int)(session: Session) -> SignalProducer<Group, RequestError> {
        return get("groups/\(groupId)", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<Group, RequestError> in
                do {
                    return try SignalProducer(value: Group.mappedInstance(input as! JSON))
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    public static func getGroupModerators(groupId: Int)(session: Session) -> SignalProducer<[User], RequestError> {
        return get("groups/\(groupId)/moderators", session: session)
            .flatMap(.Latest, transform: { (input) -> SignalProducer<[User], RequestError> in
                do {
                    guard let connections = input as? [AnyObject] else { return SignalProducer(error: .InvalidType) }
                    return try SignalProducer(value: connections.map { try User.mappedInstance($0 as! JSON) })
                }
                catch {
                    return SignalProducer(error: .MappingError(error))
                }
            })
    }
    
    /*

GET	/groups/{id}	a group
GET	/groups/{id}/moderators	list of users who moderate the group
GET	/groups/{id}/members	list of users who joined the group
GET	/groups/{id}/contributors	list of users who contributed a track to the group
GET	/groups/{id}/users	list of users who contributed to, joined or moderate the group
GET	/groups/{id}/tracks	list of contributed and approved tracks
GET	/groups/{id}/pending_tracks	list of contributed but not approved tracks (for moderators)
GET, PUT, DELETE	/groups/{id}/pending_tracks/{id}	a contributed but not approved track (for moderators)
GET, POST	/groups/{id}/contributions	list of contributed tracks (for moderators). POST creates contribution
GET, DELETE	/groups/{id}/contributions/{id}	a contributed track (for moderators)*/
    
/*
TODO
======
playlists
tracks
users
groups
me/activities
*/
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
    return parametersWithToken
}


