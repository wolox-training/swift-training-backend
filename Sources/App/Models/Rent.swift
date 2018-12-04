import FluentPostgreSQL
import Vapor

final class Rent: PostgreSQLModel {
    
    var id: Int?
    var userID: User.ID
    var bookID: Book.ID
    var from: Date
    var to: Date
    var returnedAt: Date?
    
    init(id: Int? = nil, userID: User.ID, bookID: Book.ID, from: Date, to: Date, returnedAt: Date?) {
        self.id = id
        self.userID = userID
        self.bookID = bookID
        self.from = from
        self.to = to
        self.returnedAt = returnedAt
    }
    
}

// Struct used for mapping the rent JSON response
extension Rent {

    struct RentForm: Content {
        var id: Int
        var user: User.SecuredUser
        var book: Book
        var from: Date
        var to: Date
        var returnedAt: Date?
    }
}

// Database relationships
extension Rent {
    
    var user: Parent<Rent, User> {
        return parent(\.userID)
    }
    
    var book: Parent<Rent, Book> {
        return parent(\.bookID)
    }
    
}

extension Rent: Content {}
extension Rent: Migration {}
extension Rent: Parameter {}
