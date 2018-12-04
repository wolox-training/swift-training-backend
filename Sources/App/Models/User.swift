import FluentPostgreSQL
import Vapor

final class User: PostgreSQLModel {
    
    var id: Int?
    var username: String
    var password: String
    var image: String?
        
    init(id: Int? = nil, username: String, password: String, image: String?) {
        self.id = id
        self.username = username
        self.password = password
        self.image = image
    }
    
    func getSecuredUser() -> SecuredUser {
        return SecuredUser(id: id, username: username, image: image)
    }
}

// Struct used when the passord needs to be hidden
extension User {
    
    struct SecuredUser: Content {
        var id: Int?
        var username: String
        var image: String?
    }
}

// Database relationships
extension User {
    
    var comments: Children<User, Comment> {
        return children(\.userID)
    }
    
    var rents: Children<User, Rent> {
        return children(\.userID)
    }
    
    var wishes: Children<User, Wish> {
        return children(\.userID)
    }
    
    var suggestions: Children<User, Suggestion> {
        return children(\.userID)
    }
}

extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
