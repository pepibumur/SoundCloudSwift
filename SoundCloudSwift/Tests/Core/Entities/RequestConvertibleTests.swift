//
//  RequestConvertibleTests.swift
//  SoundCloudSwift
//
//  Created by David Chavez on 9/29/15.
//  Copyright © 2015 SugarTeam. All rights reserved.
//

import Quick
import Nimble
@testable import SoundCloudSwift

class RequestConvertibleTests: QuickSpec {
    override func spec() {
        describe("sound cloud request convertibles") {
            it("generates correctly formatted URL request") {
                let params = ["q": "david chavez", "limit": 40]
                let request = RequestConvertible(path: "http://sugarteam.io", parameters: params, method: .GET).request()
                expect(request.URL!.absoluteString).to(equal("http://sugarteam.io?limit=40&q=david%20chavez"))
            }
        }
    }
}