import Foundation
import Genome

public struct Track: BasicMappable {
    
    // MARK: - Attributes
    
    /// SoundCloud Identifier
    public var id: Int = -1
    
    /// Created at date
    public var createdAt: NSDate = NSDate()
    
    /// User identifier
    public var userId: Int = -1
    
    /// Track title
    public var title: String = ""
    
    
    // MARK: - Init
    
    public init() {}
    
    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try createdAt <~ map["created_at"].transformFromJson { date($0) }
        try id <~ map["id"]
        try userId <~ map["user_id"]
        try title <~ map["title"]
    }
}