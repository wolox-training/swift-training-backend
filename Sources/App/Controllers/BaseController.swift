import Vapor
import FluentPostgreSQL

class BaseController {
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        let dateFormatter = DateUtils.getIso8601Formatter()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    internal func createGetResponse(_ req: Request, content: Any) throws -> Response {
        let response = req.response()
        response.http.status = .ok
        response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
        
        let data = try JSONSerialization.data(withJSONObject: content)
        response.http.body = HTTPBody(data: data)
        
        return response
    }
    
    internal func createPostResponse<T: Encodable>(_ req: Request, content: T) throws -> Response {
        let response = req.response()
        response.http.status = .created
        response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
        
        let data = try encoder.encode(content)
        response.http.body = HTTPBody(data: data)
        
        return response
    }
    
    internal func createComment(comment: Comment, book: Book, user: User) -> [String: Any] {
        var comment = comment.toDictionary()
        comment["book"] = book.toDictionary()
        comment["user"] = user.toDictionary()
        return comment
    }
    
    internal func createWish(wish: Wish, book: Book, user: User) -> [String: Any] {
        var wish = wish.toDictionary()
        wish["book"] = book.toDictionary()
        wish["user"] = user.toDictionary()
        return wish
    }
    
    internal func createRent(rent: Rent, book: Book, user: User) -> [String: Any] {
        var rent = rent.toDictionary()
        rent["book"] = book.toDictionary()
        rent["user"] = user.toDictionary()
        return rent
    }
    
    internal func createSuggestion(suggestion: Suggestion, user: User) -> [String: Any] {
        var suggestion = suggestion.toDictionary()
        suggestion["user"] = user.toDictionary()
        return suggestion
    }
    
}
