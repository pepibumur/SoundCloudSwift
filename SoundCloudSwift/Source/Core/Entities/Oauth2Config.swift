import Foundation

/**
 *  Entity that represents the app configuration in the SoundCloud API
 */
public struct Oauth2Config {
    
    // MARK: - Attributes
    
    /// App client identifier
    let clientId: String
    
    /// App client secret
    let clientSecret: String
    
    /// App redirect Uri
    let redirectUri: String
    
    
    // MARK: - Constructor
    
    /**
    Initializes OauthConfig
    
    - parameter clientId:     API app client id
    - parameter clientSecret: API app client secret
    - parameter redirectUri:  API app redirect uri
    
    - returns: initialized OauthConfig
    */
    public init(clientId: String, clientSecret: String, redirectUri: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
    }
}