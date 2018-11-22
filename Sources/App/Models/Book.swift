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
    
    init(id: Int? = nil, author: String, title: String, image: String?, year: String, genre: String) {
        self.id = id
        self.author = author
        self.title = title
        self.image = image
        self.year = year
        self.genre = genre
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
