import FluentPostgreSQL
import Vapor

final class Wish: PostgreSQLModel {
    
    var id: Int?
    var userID: User.ID
    var bookID: Book.ID
    
    init(id: Int? = nil, userID: User.ID, bookID: Book.ID) {
        self.id = id
        self.userID = userID
        self.bookID = bookID
    }
}

extension Wish {
    
    var user: Parent<Wish, User> {
        return parent(\.userID)
    }
    
    var book: Parent<Wish, Book> {
        return parent(\.bookID)
    }
    
}

extension Wish: Mappable {
    
    func toDictionary() -> [String : Any] {
        return [
            "id": id
        ]
    }
}

extension Wish: Content {}
extension Wish: Migration {}
extension Wish: Parameter {}
