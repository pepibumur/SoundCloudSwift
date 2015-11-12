import Foundation
import Genome

public struct Application: BasicMappable {
    
    // MARK: - Attributes
    
    var identifier: String = ""
    
    var kind: String?
    
    var name: String = ""
    
    var uri: String = ""
    
    var permalinkUrl: String = ""
    
    var externalUrl: String = ""
    
    var creator: String = ""
    
    
    // MARK: - Constructor
    
    public init() {}
    
    
    // MARK: - BasicMappable
    
    public mutating func sequence(map: Map) throws {
        try identifier <~ map["id"]
        kind = try <~?map["kind"]
        try name <~ map["name"]
        try uri <~ map["kind"]
        try permalinkUrl <~ map["permalink_uri"]
        try externalUrl <~ map["external_url"]
        try creator <~ map["creator"]
    }
}