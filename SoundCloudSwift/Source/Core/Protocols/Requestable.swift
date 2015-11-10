import Foundation
import ReactiveCocoa

/**
 *  Protocol that defines that the element can be requested to the SoundCloud API using the provided session
 */
public protocol Requestable {
    
    typealias T
    
    /**
     Request the object using the provided session
     
     - parameter session: session that authenticates the user
     
     - returns: signal producer that executes the action
     */
    func with(session: Session) -> SignalProducer<T, ApiError>

}