import Foundation

/**
*  It represents an API session
*/
public struct Session: KeyValueStorable {
    
    /**
    SoundCloud API scopes
    
    - All:  Access all features
    - Some: Access some features
    */
    public enum Scope {
        case All
        case Some([String])
        
        func toString() -> String {
            switch self {
            case .All:
                return "*"
            case .Some(let scopes):
                return scopes.joinWithSeparator(",")
            }
        }
        
        static func fromString(string: String) -> Scope {
            if string == "*" { return .All }
            return .Some(string.componentsSeparatedByString(","))
        }
    }
    
    // MARK: - Attributes
    
    /// Access token (needed to authorize requests)
    let accessToken: String
    
    /// Session scope
    let scope: Scope
    
    
    // MARK: - Constructors
    
    /**
    Default constructor
    
    - parameter accessToken: session access token
    - parameter scope:       session scope
    
    - returns: initialized session
    */
    init(accessToken: String, scope: Scope) {
        self.accessToken = accessToken
        self.scope = scope
    }
    
    
    // MARK: - KeyValueStorable
    
    private struct StorableKeys {
        static let accessTokenKey: String = "access-token"
        static let scopeKey: String = "scope"
    }
    
    public func storeDict() -> [String: String] {
        var dict: [String: String] = [:]
        dict[StorableKeys.accessTokenKey] = accessToken
        dict[StorableKeys.scopeKey] = scope.toString()
        return dict
    }

    public init(storeDict: [String: String]) throws {
        guard let _accessToken = storeDict[StorableKeys.accessTokenKey] else { throw StorableError.InvalidData(StorableKeys.accessTokenKey) }
        guard let _scope = storeDict[StorableKeys.scopeKey] else { throw StorableError.InvalidData(StorableKeys.scopeKey) }
        self.accessToken = _accessToken
        self.scope = Scope.fromString(_scope)
    }
}