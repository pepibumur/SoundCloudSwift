import Foundation

/// Track filter
/// Reference: https://developers.soundcloud.com/docs/api/reference#tracks
public enum TrackFilter: Filter {
    
    /// Track visibility
    public enum Visibility: String {
        case All, Public, Private
    }
    
    case Query(String)
    case Tags([String])
    case Filter(Visibility)
    case License(String)
    case BpmFrom(Int)
    case BpmTo(Int)
    case DurationTo(Int)
    case From(NSDate)
    case To(NSDate)
    case Ids([Int])
    case Genres([String])
    case Types([String])
    
    
    // MARK: - Filter
    
    func toDict() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        switch self {
        case .Query(let query):
            dict["q"] = query
        case .Tags(let tags):
            dict["tags"] = tags.joinWithSeparator(",")
        case .Filter(let visibility):
            dict["filter"] = visibility.rawValue.lowercaseString
        case .License(let license):
            dict["license"] = license
        case .BpmFrom(let from):
            dict["bpm[from]"] = from
        case .BpmTo(let from):
            dict["bpm[to]"] = from
        case .DurationTo(let from):
            dict["duration[to]"] = from
        case .From(let from):
            dict["created_at[from]"] = date(from)
        case .To(let to):
            dict["created_at[to]"] = date(to)
        case .Ids(let ids):
            dict["ids"] = ids.map({"\($0)"}).joinWithSeparator(",")
        case .Genres(let genres):
            dict["genres"] = genres.joinWithSeparator(",")
        case .Types(let types):
            dict["types"] = types.joinWithSeparator(",")
        }
        return dict
    }
}