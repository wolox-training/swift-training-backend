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
    
    struct WishForm: Content {
      
        init(id: Int, user: User? = nil, book: Book? = nil) {
            self.id = id
            self.user = user
            self.book = book
        }
        
        var id: Int
        var user: User?
        var book: Book?
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

extension Wish: Content {}
extension Wish: Migration {}
extension Wish: Parameter {}
