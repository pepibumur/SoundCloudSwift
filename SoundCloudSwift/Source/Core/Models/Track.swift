import Foundation

public struct Track {
    
    // MARK: - Attributes
    
    var identifier: String = ""
    
    var url: NSURL = NSURL(string: "")!
}


// MARK: - Track extension (Equatable)

extension Track: Equatable {}

public func ==(lhs: Track, rhs: Track) -> Bool{
    return lhs.identifier == rhs.identifier
}