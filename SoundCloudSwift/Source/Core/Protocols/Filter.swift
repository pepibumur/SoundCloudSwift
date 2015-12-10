import Foundation

/// Protocol that defines a filter.
internal protocol Filter {
    
    func toDict() -> [String: AnyObject]
}