import Foundation

/**
*  Protocol that defines that an object is storable in a KeyValue store
*/
public protocol KeyValueStorable {
    
    /**
    Stores the object in the given store
    
    - parameter key:   key that will identify the object in the store
    - parameter store: store where the object is going to be stored
    
    */
    func store<T: KeyValueStore>(key: String, store: T)

    /**
    Restore from the given store
    
    - parameter key:   key that identifies the object int he store
    - parameter store: store where the object is going to be retrieved from
    
    - returns: object from the store
    */
    static func restore<T: KeyValueStore>(key: String, store: T) throws -> Self?
    
    /**
    Clears the object under the given key
    
    - parameter key:   key that identifies the object in the store
    - parameter store: store where the object is persisted
    
    */
    static func clear<T: KeyValueStore>(key: String, store: T)
    
    /**
    Returns a dictionary with the data to be stored
    
    - returns: dictionary with the data to be stored
    */
    func storeDict() -> [String: String]
    
    /**
    Initializes the object form the store data
    
    - parameter storeDict: data used to initialize the object
    
    - throws: throws an StorableError if the provided data is not right
    
    - returns: initialized instance
    */
    init(storeDict: [String: String]) throws
}

// MARK: - KeyValueStorable extension

public extension KeyValueStorable {
    
    public func store<T: KeyValueStore>(key: String, store: T) {
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(self.storeDict())
        store.setData(data, key: key)
    }
    
    public static func restore<T: KeyValueStore>(key: String, store: T) throws -> Self? {
        guard let data = store.getData(key) else { return nil }
        guard let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: String] else { return nil }
        return try Self(storeDict: dict)
    }
    
    public static func clear<T: KeyValueStore>(key: String, store: T) {
        store.clear(key)
    }
}