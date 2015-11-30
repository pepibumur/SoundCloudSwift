import Foundation

public enum RequestError: ErrorType {
    case HTTPError(NSError)
    case MappingError(ErrorType)
    case InvalidType
}