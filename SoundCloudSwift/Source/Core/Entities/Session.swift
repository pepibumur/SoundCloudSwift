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
    let expiresDate: NSDate
    
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
        self.expiresDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(expiresIn))
        self.scope = scope
    }
    
    /**
     Initializes the Session from a dictionary
     
     - parameter dictionary: dictionary with session information
     
     - returns: initialized session
     */
    init(dictionary: [String: AnyObject]) {
        let _accessToken = dictionary["access_token"] as! String
        let _expiresIn = dictionary["expires_in"] as! Int
        let _refreshToken = dictionary["refresh_token"] as! String
        let _scope = Scope.fromString(dictionary["scope"] as! String)
        self.init(accessToken: _accessToken, refreshToken: _refreshToken, expiresIn: _expiresIn, scope: _scope)
    }
    
    
    // MARK: - Public
    
    var expired: Bool {
        get {
            return expiresDate.timeIntervalSince1970 > NSDate().timeIntervalSince1970
        }
    }
    
    
    // MARK: - KeyValueStorable
    
    private struct StorableKeys {
        static let accessTokenKey: String = "access-token"
        static let refreshTokenKey: String = "refresh-token"
        static let expiresDateKey: String = "expires-date"
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
        guard let _expiresDate = storeDict[StorableKeys.expiresDateKey] as? NSDate else { throw StorableError.InvalidData(StorableKeys.expiresDateKey) }
        guard let _scope = storeDict[StorableKeys.scopeKey] as? String else { throw StorableError.InvalidData(StorableKeys.scopeKey) }
        self.accessToken = _accessToken
        self.scope = Scope.fromString(_scope)
        self.expiresDate = _expiresDate
        self.refreshToken = _refreshToken
    }
}