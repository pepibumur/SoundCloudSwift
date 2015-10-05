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

            })
        }
        
        describe("cleaners") { () -> Void in
            let key: String = "my-key"
            let value: String = "my-value"
            store.setString(value, key: key)
            store.clearAll()
            expect(store.getString(key)).to(beNil())
        }
    }
    
}