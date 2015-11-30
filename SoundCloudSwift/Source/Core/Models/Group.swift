import Foundation
import Genome

/**
 *  SoundCloud Group
 */
public struct Group: BasicMappable {
    
    // MARK: - Attributes
    
    /// Created at date
    public var createdAt: NSDate = NSDate()
    
    /// SoundCloud Identifier
    public var id: Int = -1
    
    /// Permalink
    public var permalink: String = ""
    
    /// Name
    public var name: String = ""
    
    /// Short description
    public var shortDescription: String = ""
    
    /// Description
    public var description: String = ""
    
    /// URI
    public var uri: String = ""
    
    /// Artwork URL
    public var artworkUrl: String?
    
    /// Permalink URL
    public var permalinkUrl: String = ""
    
    /// Creator identifier
    public var creatorId: Int = -1

    
    // MARK: - Constructors
    
    public init() {}
    
    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try createdAt <~ map["created_at"].transformFromJson { date($0) }
        try id <~ map["id"]
        try permalink <~ map["permalink"]
        try name <~ map["name"]
        try shortDescription <~ map["short_description"]
        try description <~ map["description"]
        try uri <~ map["uri"]
        artworkUrl = try <~?map["artwork_url"]
        try permalinkUrl <~ map["permalink_url"]
        try creatorId <~ map["creator"]["id"]
    }
}