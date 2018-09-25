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

extension Rent {
    
    var user: Parent<Rent, User> {
        return parent(\.userID)
    }
    
    var book: Parent<Rent, Book> {
        return parent(\.bookID)
    }
    
}


extension Rent: Mappable {
    
    func toDictionary() -> [String : Any] {
        let formatter = DateUtils.getIso8601Formatter()
        
        var dictionary: [String: Any] = [
            "id": id,
            "from": formatter.string(from: from),
            "to": formatter.string(from: to)
        ]
        
        if returnedAt != nil {
            dictionary["returnedAt"] = formatter.string(from: returnedAt!)
        }
        
        return dictionary
    }
}

extension Rent: Content {}
extension Rent: Migration {}
extension Rent: Parameter {}
