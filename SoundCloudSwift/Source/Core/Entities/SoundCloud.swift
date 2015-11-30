import Foundation
import ReactiveCocoa
import Genome
import Alamofire

public struct SoundCloud {
    
    // MARK: - Me
    
    /**
    Gets user profile
    
    - parameter session: session
    
    - returns: signal producer that executes the action
    */
    public static func me(session: Session) -> SignalProducer<User, RequestError> {
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
    
    public static func connections(session: Session) -> SignalProducer<Connection, RequestError> {
        return SignalProducer.empty
    }
    
    public static func activities(session: Session) -> SignalProducer<Connection, RequestError> {
        return SignalProducer.empty
    }
    
    public static func apps(session: Session) -> SignalProducer<Application, RequestError> {
        return SignalProducer.empty
    }
}

private func get(path: String, session: Session) -> SignalProducer<AnyObject, RequestError> {
    let url: NSURL = NSURL(string: "https://api.soundcloud.com")!.URLByAppendingPathComponent(path)
    let parameters = ["oauth_token": session.accessToken]
    return SignalProducer { (observer, disposable) in
        Alamofire.request(.GET, url.absoluteString, parameters: parameters, encoding: .URL, headers: nil)
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


