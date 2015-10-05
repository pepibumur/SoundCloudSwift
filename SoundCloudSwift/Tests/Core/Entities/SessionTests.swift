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
        
        describe("storable protocol") { () -> Void in
            
            let store: SecureStore = SecureStore()
            
            it("should properly save and restore a session on a given store") {
                let scope: Session.Scope = .All
                let accessToken: String = "access-token"
                let session: Session = Session(accessToken: accessToken, scope: scope)
                session.store("session", store: store)
                let restoredSession: Session = try! Session.restore("session", store: store)!
                expect(restoredSession.accessToken) == accessToken
                switch restoredSession.scope {
                case .All:
                    expect(true) == true
                default:
                    expect(true) == false
                }
                Session.clear("session", store: store)
            }
            
            it("should properly clear the session from a given store") {
                let scope: Session.Scope = .All
                let accessToken: String = "access-token"
                let session: Session = Session(accessToken: accessToken, scope: scope)
                session.store("session", store: store)
                Session.clear("session", store: store)
                expect{ try Session.restore("session", store: store)}.to(throwError())
            }
            
        }
    
    }
    
}