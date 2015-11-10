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
    
    /// Refresh tooken (needed to refresh the access token)
    let refreshToken: String
    
    /// Time until access token expiration
    let expiresIn: Int
    
    /// Session scope
    let scope: Scope
    
    
    // MARK: - Constructors
    
    /**
    Default constructor
    
    - parameter accessToken:    session access token
    - parameter refreshToken:   session refresh token
    - parameter expiresIn:      session expires in time
    - parameter scope:          session scope
    
    - returns: initialized session
    */
    init(accessToken: String, refreshToken: String, expiresIn: Int, scope: Scope) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.scope = scope
    }
    
    /**
     Initializes the Session from a dictionary
     
     - parameter dictionary: dictionary with session information
     
     - returns: initialized session
     */
    init(dictionary: [String: AnyObject]) {
        self.accessToken = dictionary["access_token"] as! String
        self.expiresIn = dictionary["expires_in"] as! Int
        self.refreshToken = dictionary["refresh_token"] as! String
        self.scope = Scope.fromString(dictionary["scope"] as! String)
    }
    
    
    // MARK: - KeyValueStorable
    
    private struct StorableKeys {
        static let accessTokenKey: String = "access-token"
        static let refreshTokenKey: String = "refresh-token"
        static let expiresInKey: String = "expires-in"
        static let scopeKey: String = "scope"
    }
    
    public func storeDict() -> [String: String] {
        var dict: [String: String] = [:]
        dict[StorableKeys.accessTokenKey] = accessToken
        dict[StorableKeys.scopeKey] = scope.toString()
        return dict
    }

    public init(storeDict: [String: AnyObject]) throws {
        guard let _accessToken = storeDict[StorableKeys.accessTokenKey] as? String else { throw StorableError.InvalidData(StorableKeys.accessTokenKey) }
        guard let _refreshToken = storeDict[StorableKeys.refreshTokenKey] as? String else { throw StorableError.InvalidData(StorableKeys.refreshTokenKey) }
        guard let _expiresIn = storeDict[StorableKeys.expiresInKey] as? Int else { throw StorableError.InvalidData(StorableKeys.expiresInKey) }
        guard let _scope = storeDict[StorableKeys.scopeKey] as? String else { throw StorableError.InvalidData(StorableKeys.scopeKey) }
        self.accessToken = _accessToken
        self.scope = Scope.fromString(_scope)
        self.expiresIn = _expiresIn
        self.refreshToken = _refreshToken
    }
}