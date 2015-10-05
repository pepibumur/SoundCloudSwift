//
//  SecureStoreTests.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SoundCloudSwift

class SecureStoreTests: QuickSpec {
    
    override func spec() {
        
        let store: SecureStore = SecureStore()
        
        beforeEach { () -> () in
            store.clearAll()
        }
        
        describe("accessors") { () -> Void in
            
            it("should properly persist a string", closure: { () -> () in
                let key: String = "my-key"
                let value: String = "my-value"
                store.setString(value, key: key)
                expect(store.getString(key)) == value
            })
            
            it("should properly persist data", closure: { () -> () in
                let value: String = "my-value"
                let data: NSData = value.dataUsingEncoding(NSUTF8StringEncoding)!
                let key: String = "my-key"
                store.setData(data, key: key)
                let restoredData: NSData? = store.getData(key)
                expect(String(data: restoredData!, encoding: NSUTF8StringEncoding)) == value
            })
        }
        
        describe("cleaners") { () -> Void in
            it("should clear all the information with clearAll") {
                let key: String = "my-key"
                let value: String = "my-value"
                store.setString(value, key: key)
                store.clearAll()
                expect(store.getString(key)).to(beNil())
            }
            
            it("should clear the information under the given key") {
                let key: String = "my-key"
                let value: String = "my-value"
                store.setString(value, key: key)
                store.clear(key)
                expect(store.getString(key)).to(beNil())
            }
        }
    }
    
}