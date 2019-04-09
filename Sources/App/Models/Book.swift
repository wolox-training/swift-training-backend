import FluentPostgreSQL
import Vapor
import Pagination

final class Book: PostgreSQLModel {
    
    var id: Int?
    var author: String
    var title: String
    var image: String?
    var year: String
    var genre: String
    var status: String?
    
    func willCreate(on conn: PostgreSQLConnection) throws -> EventLoopFuture<Book> {
        self.status = "Available"
        return Future.map(on: conn) { self }
    }
}

// Database relationships
extension Book {
    
    var comments: Children<Book, Comment> {
        return children(\.bookID)
    }
    
    var rents: Children<Book, Rent> {
        return children(\.bookID)
    }
    
    var wishes: Children<Book, Wish> {
        return children(\.bookID)
    }
}

extension Book: Content {}
extension Book: Migration {}
extension Book: Parameter {}
extension Book: Paginatable {}
