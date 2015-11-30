import Foundation
import Genome

/**
 *  SoundCloud Application
 */
public struct Application: BasicMappable {
    
    // MARK: - Attributes
    
    /// Identifier
    var identifier: Int = -1
    
    /// Kind
    var kind: String?
    
    /// Name
    var name: String = ""
    
    /// URI
    var uri: String = ""
    
    /// Permalink URL
    var permalinkUrl: String = ""
    
    /// External URL
    var externalUrl: String?
    
    /// Creator name
    var creator: String?
    
    
    // MARK: - Constructor
    
    public init() {}
    
    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try identifier <~ map["id"]
        kind = try <~?map["kind"]
        try name <~ map["name"]
        try uri <~ map["kind"]
        try permalinkUrl <~ map["permalink_url"]
        externalUrl = try <~?map["external_url"]
        creator = try <~?map["creator"]
    }
}