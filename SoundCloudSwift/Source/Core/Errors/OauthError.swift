import Foundation

public enum OauthError: ErrorType {
    case AuthorizationUrlGeneration(NSError)
    case StateInconsistence
    case InvalidRedirectUrl
    case MissingParameter
    case StateMismatch
    case APIError(NSError)
    case InvalidResponse
    case TokenNotFound
    case Unknown
}