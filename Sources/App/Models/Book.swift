import FluentPostgreSQL
import Vapor
import Pagination

final class Book: PostgreSQLModel {
    
    var id: Int?
    let author: String
    let title: String
    let image: String?
    let year: String
    let genre: String
    
    init(id: Int? = nil, author: String, title: String, image: String?, year: String, genre: String) {
        self.id = id
        self.author = author
        self.title = title
        self.image = image
        self.year = year
        self.genre = genre
    }
}

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

extension Book: Mappable {
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "author": author,
            "title": title,
            "year": year,
            "genre": genre
        ]
        
        if image != nil {
            dictionary["image"] = image
        }
        
        return dictionary
    }
}

extension Book: Content {}
extension Book: Migration {}
extension Book: Parameter {}
extension Book: Paginatable {}
