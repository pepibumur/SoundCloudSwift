import Quick
import Nimble

@testable import SoundCloudSwift

class RequestConvertibleTests: QuickSpec {
    override func spec() {
        describe("sound cloud request convertibles") {
            it("generates correctly formatted URL request") {
                let params = ["q": "pedro pinera", "limit": 40]
                let request = RequestConvertible(path: "http://gitdo.io", parameters: params, method: .GET).request()
                expect(request.URL!.absoluteString).to(equal("http://gitdo.io?limit=40&q=pedro%20pinera"))
            }
        }
    }
}