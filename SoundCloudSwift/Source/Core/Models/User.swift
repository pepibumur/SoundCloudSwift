import Foundation
import Genome

/**
 *  SoundCloud User
 */
public struct  User: BasicMappable {

    // MARK: - Attributes
    
    public var identifier: Int = -1
    public var permalink: String = ""
    public var username: String = ""
    public var uri: String = ""
    public var permalinkUrl: String = ""
    public var avatarUrl: String = ""
    public var country: String = ""
    public var fullName: String = ""
    public var city: String?
    public var description: String?
    public var discogsName: String?
    public var myspaceName: String?
    public var website: String?
    public var online: Bool = false
    public var tracksCount: Int?
    public var playlistCount: Int?
    public var followersCount: Int = 0
    public var followingsCount: Int = 0
    public var publicFavoritesCount: Int = 0
    public var plan: String = ""
    public var privateTracksCount: Int = 0
    public var privatePlaylistsCount: Int = 0
    public var primaryEmailConfirmed: Bool = false


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
        try plan <~ map["plan"]
        try privateTracksCount <~ map["private_tracks_count"]
        try privatePlaylistsCount <~ map["private_playlists_count"]
        try primaryEmailConfirmed <~ map["primary_email_confirmed"]
    }
}