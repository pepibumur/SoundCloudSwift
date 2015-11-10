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
    
    /**
    Saves a string under a provider key
    
    - parameter value: value
    - parameter key:   key
    */
    public func setString(value: String, key: String) {
        keychain.set(value, forKey: key)
    }
    
    /**
     Saves data under a provided key
     
     - parameter value: data to be saved
     - parameter key:   key
     */
    public func setData(value: NSData, key: String) {
        keychain.set(value, forKey: key)
    }
    
    /**
     Returns the data under the given key
     
     - parameter key: key that references the data
     
     - returns: data
     */
    public func getData(key: String) -> NSData? {
        return keychain.getData(key)
    }
    
    /**
     Returns the string under the given key
     
     - parameter key: key that references the string
     
     - returns: string
     */
    public func getString(key: String) -> String? {
        return keychain.get(key)
    }
    
    
    // MARK: - Helpers
    
    /**
    Clears the element store under the given key
    
    - parameter key: key that references the element
    */
    public func clear(key: String) {
        keychain.delete(key)
    }
    
    /**
     Clears all the stored elements
     */
    public func clearAll() {
        keychain.clear()
    }
}