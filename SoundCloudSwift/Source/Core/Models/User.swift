import Foundation
import Genome

/**
 *  SoundCloud User
 */
public struct  User: BasicMappable {

    // MARK: - Attributes
    
    /// Identifier
    public var identifier: Int = -1
    
    /// Permalink
    public var permalink: String = ""
    
    /// Username
    public var username: String = ""
    
    /// URI
    public var uri: String = ""
    
    /// Permalink URL
    public var permalinkUrl: String = ""
    
    /// Avatar URL
    public var avatarUrl: String = ""
    
    /// Country
    public var country: String = ""
    
    /// Full name
    public var fullName: String = ""
    
    /// City
    public var city: String?
    
    /// Description
    public var description: String?
    
    /// Discogs name
    public var discogsName: String?
    
    /// MySpace name
    public var myspaceName: String?
    
    /// Website
    public var website: String?
    
    /// Online status
    public var online: Bool = false
    
    /// Number of tracks
    public var tracksCount: Int?
    
    /// Number of playlists
    public var playlistCount: Int?
    
    /// Number of followers
    public var followersCount: Int = 0
    
    /// Number of followings
    public var followingsCount: Int = 0
    
    /// Public favorites count
    public var publicFavoritesCount: Int = 0
    
    /// Plan
    public var plan: String?
    
    /// Private tracks count
    public var privateTracksCount: Int?
    
    /// Private playlists count
    public var privatePlaylistsCount: Int?
    
    /// True if the primary email is confirmed
    public var primaryEmailConfirmed: Bool?


    // MARK: - Constructors
    
    public init() {}

        
    // MARK: - BasicMappable

    public mutating func sequence(map: Map) throws {
        try identifier <~ map["id"]
        try permalink <~ map["permalink"]
        try username <~ map["username"]
        try username <~ map["uri"]
        try permalinkUrl <~ map["permalink_url"]
        try avatarUrl <~ map["avatar_url"]
        try country <~ map["country"]
        try fullName <~ map["full_name"]
        description = try <~?map["description"]
        city = try <~?map["city"]
        discogsName = try <~?map["discogs-name"]
        myspaceName = try <~?map["myspace-name"]
        website = try <~?map["website"]
        try online <~ map["online"]
        tracksCount = try <~?map["tracks_count"]
        playlistCount = try <~?map["playlists_count"]
        try followersCount <~ map["followers_count"]
        try followingsCount <~ map["followings_count"]
        try publicFavoritesCount <~ map["public_favorites_count"]
        plan = try <~?map["plan"]
        privateTracksCount = try <~?map["private_tracks_count"]
        privatePlaylistsCount = try <~?map["private_playlists_count"]
        primaryEmailConfirmed = try <~?map["primary_email_confirmed"]
    }
}