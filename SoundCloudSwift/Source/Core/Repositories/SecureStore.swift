//
//  SecureStore.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation
import KeychainSwift

/**
*  Store that persist the data on a secure environment
*/
public struct SecureStore: KeyValueStore {
    
    // MARK: - Attributes
    
    /// Keychain object to persist the data
    let keychain = KeychainSwift()
    
    
    // MARK: - KeyValueStore
    
    func setString(value: String, key: String) {
        keychain.set(value, forKey: key)
    }
    
    func setData(value: NSData, key: String) {
        keychain.set(value, forKey: key)
    }
    
    func getData(key: String) -> NSData? {
        return keychain.getData(key)
    }
    
    func getString(key: String) -> String? {
        return keychain.get(key)
    }
    
    // MARK: - Helpers
    
    func clearAll() {
        keychain.clear()
    }
}