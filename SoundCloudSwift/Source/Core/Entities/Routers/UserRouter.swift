import Foundation

extension User {
    
    enum Router: Path {
        case Me
        
        
        // MARK: - Path
        
        var path: String {
            get {
                switch self {
                case .Me:
                    return "me"
                }
            }
        }
    }
}