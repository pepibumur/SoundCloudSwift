import Foundation
import Genome

/**
 *  SoundCloud Connection
 */
public struct Connection: BasicMappable{
    
    // MARK: - Attributes
    
    /// Created at date
    public var createdAt: NSDate = NSDate()
    
    /// Display name
    public var displayName: String = ""
    
    /// SoundCloud Identifier
    public var id: Int = -1
    
    /// Post favorite
    public var postFavorite: Bool = false
    
    /// Post publish
    public var postPublish: Bool = false
    
    /// Service
    public var service: String = ""
    
    /// Type
    public var type: String = ""
    
    /// URI
    public var uri: String = ""
    
    
    // MARK: - Constructors
    
    public init() {}

    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try createdAt <~ map["created_at"].transformFromJson { date($0) }
        try displayName <~ map["display_name"]
        try id <~ map["id"]
        try postFavorite <~ map["post_favorite"]
        try postPublish <~ map["post_publish"]
        try service <~ map["service"]
        try type <~ map["type"]
        try uri <~ map["uri"]
    }
}