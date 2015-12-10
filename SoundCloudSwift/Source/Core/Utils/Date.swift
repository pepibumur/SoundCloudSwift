import Foundation

internal func date(string: String) -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
    return formatter.dateFromString(string)!
}

internal func date(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
    return formatter.stringFromDate(date)
}