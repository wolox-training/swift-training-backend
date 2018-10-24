import Vapor
import FluentPostgreSQL

final class SuggestionController {
    
    func list(_ req: Request) throws -> Future<[Suggestion.SuggestionForm]> {
        let futureSuggestions = Suggestion.query(on: req)
            .join(\User.id, to: \Suggestion.userID)
            .alsoDecode(User.self)
            .all()
        
        return futureSuggestions.map { suggestionList in
            return try suggestionList.map { (suggestion, user) in
                return try Suggestion.SuggestionForm(id: suggestion.requireID(),
                                                     title: suggestion.title,
                                                     author: suggestion.author,
                                                     link: suggestion.link,
                                                     user: user)
            }
        }
    }
    
    func show(_ req: Request) throws -> Future<Suggestion.SuggestionForm> {
        let futureSuggestion = try req.parameters.next(Suggestion.self)
        
        let futureSuggestionAndUser = futureSuggestion.flatMap { suggestion in
            return Suggestion.query(on: req)
                .filter(\Suggestion.id == suggestion.id)
                .join(\User.id, to: \Suggestion.userID)
                .alsoDecode(User.self)
                .first()
                .unwrap(or: Abort(.notFound))
        }
        
        return futureSuggestionAndUser.map { (suggestion, user) in
            return try Suggestion.SuggestionForm(id: suggestion.requireID(),
                                                 title: suggestion.title,
                                                 author: suggestion.author,
                                                 link: suggestion.link,
                                                 user: user)
        }
    }
    
    func create(_ req: Request) throws -> Future<Response> {
        let futureSuggestion = try req.content.decode(Suggestion.self).flatMap { suggestion in
            return suggestion.save(on: req)
        }
        
        return futureSuggestion.encode(status: .created, for: req)
    }
}