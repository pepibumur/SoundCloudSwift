import Foundation
import Mockingjay
import Quick
import Nimble

@testable import SoundCloudSwift

class SoundCloudTests: QuickSpec {
    override func spec() {
        describe("REST requests") {
            context("GET", {
                
                var session: Session?
                
                beforeSuite {
                    session = Session(accessToken: "token", refreshToken: "refresh", expiresIn: 200, scope: .All)
                }
                
                it("should return the object and completed if the response has been successful") {
                    self.stub(uri("https://api.soundcloud.com/testpath"), builder: json("{}", status: 200, headers: [:]))
                    waitUntil(action: { (done) -> Void in
                        SoundCloud.get("testpath/", session: session!).on(event: { event in
                            switch event {
                            case .Next(let value):
                                expect(value as? [String: String]) == ["status": "ok"]
                            case .Failed(let error):
                                print("AAA \(error)")
                            case .Completed:
                                done()
                            default: break
                            }
                        }).start()
                        
                    })
                }
                
                it("should return an error if something went wrong") {
                    
                }

                afterEach {
                    self.removeAllStubs()
                }
            })
        }
        
    }
}