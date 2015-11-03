import Foundation

public enum OauthError: ErrorType {
    case AuthorizationUrlGeneration(NSError)
    case Unknown
}