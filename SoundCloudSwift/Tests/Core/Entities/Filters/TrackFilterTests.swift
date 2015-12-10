import Foundation
import Quick
import Nimble

@testable import SoundCloudSwift

class TrackFilterTests: QuickSpec {
    override func spec() {
        describe("filter") {
            it("should create the correct dict for query") {
                expect(TrackFilter.Query("olakase").toDict() as? [String: String]) == ["q": "olakase"]
            }
            it("should create the correct dict for tags") {
                expect(TrackFilter.Tags(["1", "2"]).toDict() as? [String: String]) == ["tags": "1,2"]
            }
            context("filter") {
                it("should create the correct dict for all filter") {
                    expect(TrackFilter.Filter(.All).toDict() as? [String: String]) == ["filter": "all"]
                }
                it("should create the correct dict for public filter") {
                    expect(TrackFilter.Filter(.Public).toDict() as? [String: String]) == ["filter":
                        "public"]
                }
                it("should create the correct dict for private filter") {
                    expect(TrackFilter.Filter(.Private).toDict() as? [String: String]) == ["filter": "private"]
                }
            }
            it("should create the correct dict for license") {
                expect(TrackFilter.License("mit").toDict() as? [String: String]) == ["license": "mit"]
            }
            it("should create the correct dict for bpm[from]") {
                expect(TrackFilter.BpmFrom(3).toDict() as? [String: Int]) == ["bpm[from]": 3]
            }
            it("should create the correct dict for bpm[to]") {
                expect(TrackFilter.BpmTo(3).toDict() as? [String: Int]) == ["bpm[to]": 3]
            }
            it("should create the correct dict for duration[to]") {
                expect(TrackFilter.DurationTo(3).toDict() as? [String: Int]) == ["duration[to]": 3]
            }
            it("should create the correct dict for created_at[from]") {
                let _date = NSDate()
                expect(TrackFilter.From(_date).toDict() as? [String: String]) == ["created_at[from]": date(_date)]
            }
            it("should create the correct dict for created_at[to]") {
                let _date = NSDate()
                expect(TrackFilter.To(_date).toDict() as? [String: String]) == ["created_at[to]": date(_date)]
            }
            it("should create the correct dict for ids") {
                expect(TrackFilter.Ids([3, 4]).toDict() as? [String: String]) == ["ids": "3,4"]
            }
            it("should create the correct dict for genres") {
                expect(TrackFilter.Genres(["pop", "rock"]).toDict() as? [String: String]) == ["genres": "pop,rock"]
            }
            it("should create the correct dict for types") {
                expect(TrackFilter.Types(["test1", "test2"]).toDict() as? [String: String]) == ["types": "test1,test2"]
            }
        }
    }
}