//
//  Store.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation

/**
*  Protocol that defines a Key-Value store
*/
public protocol KeyValueStore {
    
    // MARK: - Accessors
    
    /**
    Persists the value under the providen key
    
    - parameter value: value to be persisted
    - parameter key:   key that references the value in the store
    
    */
    func setString(value: String, key: String)
    
    /**
    Persists the provided data under the providen key
    
    - parameter value: data to be persisted
    - parameter key:   key that references the value in the store
    
    */
    func setData(value: NSData, key: String)
    
    /**
    Gets the data referenced by the key in the store
    
    - parameter key: key that references the data
    
    - returns: data
    */
    func getData(key: String) -> NSData?
    
    /**
    Gets the string referenced by the key in the store
    
    - parameter key: key that references the string
    
    - returns: string
    */
    func getString(key: String) -> String?
    
    
    // MARK: - Helpers
    
    /**
    Clears the object under the given key
    
    - parameter key: key that identifies the object in the store
    */
    func clear(key: String)
    
    /**
    Clears all the information in the store
    */
    func clearAll()
}