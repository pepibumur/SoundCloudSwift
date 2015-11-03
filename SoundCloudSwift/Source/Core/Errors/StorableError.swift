import Foundation

/**
*  Errors thrown by the Storable protocol
*/
public enum StorableError: ErrorType {
    case InvalidData(String)
    case MissingData(String)
}