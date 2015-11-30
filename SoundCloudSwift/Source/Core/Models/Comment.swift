import Foundation
import Genome

/**
 *  SoundCloud Comment
 */
public struct Comment: BasicMappable {
    
    // MARK: - Attributes
    
    /// Created at date
    public var createdAt: NSDate = NSDate()
    
    /// SoundCloud Identifier
    public var id: Int = -1
    
    /// User identifier
    public var userId: Int = -1
    
    /// Track identifier
    public var trackId: Int = -1
    
    /// Timestamp
    public var timestamp: Int = -1
    
    /// Body
    public var body: String = ""
    
    /// URI
    public var uri: String = ""
    
    
    // MARK: - Constructors
    
    public init() {}
    
    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try createdAt <~ map["created_at"].transformFromJson { date($0) }
        try id <~ map["id"]
        try userId <~ map["user_id"]
        try trackId <~ map["track_id"]
        try timestamp <~ map["timestamp"]
        try body <~ map["body"]
        try uri <~ map["uri"]
    }
}