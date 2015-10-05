//
//  SessionTests.swift
//  SoundCloudSwift
//
//  Created by Pedro Pinera Buendia on 05/10/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SoundCloudSwift

class SessionTests: QuickSpec {

    override func spec() {
        
        describe("scope") { () -> Void in
            
            it("should return the proper string that identifies the scope", closure: { () -> () in
                expect(Session.Scope.All.toString()) == "*"
                expect(Session.Scope.Some(["one", "two", "three"]).toString()) == "one,two,three"
            })
            
            it("should be properly initialized from a string", closure: { () -> () in
                switch Session.Scope.fromString("*") {
                case .All:
                    expect(true) == true
                case .Some(_):
                    expect(true) == false
                }
                switch Session.Scope.fromString("a,b,c") {
                case .All:
                    expect(true) == false
                case .Some(let scopes):
                    expect(scopes) == ["a", "b", "c"]
                }
            })
            
        }
    
    }
    
}