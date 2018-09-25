import FluentPostgreSQL
import Vapor

final class Comment: PostgreSQLModel {
    
    var id: Int?
    var content: String
    var userID: User.ID
    var bookID: Book.ID
    
    init(id: Int? = nil, content: String, userID: User.ID, bookID: Book.ID) {
        self.id = id
        self.content = content
        self.userID = userID
        self.bookID = bookID
    }
    
}

extension Comment {
    
    var user: Parent<Comment, User> {
        return parent(\.userID)
    }
    
    var book: Parent<Comment, Book> {
        return parent(\.bookID)
    }
    
}


extension Comment: Mappable {
    
    func toDictionary() -> [String : Any] {
        return [
            "id": id,
            "content": content
        ]
    }
}

extension Comment: Content {}
extension Comment: Migration {}
extension Comment: Parameter {}
