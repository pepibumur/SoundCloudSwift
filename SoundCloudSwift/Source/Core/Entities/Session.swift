//
//  Session.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation

/**
*  It represents an API session
*/
public struct Session {
    
    /**
    SoundCloud API scopes
    
    - All:  Access all features
    - Some: Access some features
    */
    enum Scope {
        case All
        case Some([String])
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
}