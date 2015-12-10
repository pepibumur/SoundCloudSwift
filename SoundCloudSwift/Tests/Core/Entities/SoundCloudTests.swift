import Foundation
import Mockingjay
import Quick
import Nimble

@testable import SoundCloudSwift

class SoundCloudTests: QuickSpec {
    override func spec() {
        describe("REST requests") {
            sharedExamples("REST", { (context) -> Void in
                
            })
        }
    }
}