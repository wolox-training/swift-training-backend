import Vapor
import FluentPostgreSQL

final class SuggestionController {
    
    /// Obtains the complete list of suggestions
    ///
    /// - Parameter req: current request
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
    
    /// Obtains a specific suggestion
    ///
    /// - Parameter req: current request
    func show(_ req: Request) throws -> Future<Suggestion.SuggestionForm> {
        let futureSuggestion = try req.parameters.next(Suggestion.self)
        
        return futureSuggestion.flatMap { suggestion in
            return suggestion.user.get(on: req).map { user in
                return try Suggestion.SuggestionForm(id: suggestion.requireID(),
                                                     title: suggestion.title,
                                                     author: suggestion.author,
                                                     link: suggestion.link,
                                                     user: user)
            }
        }
    }
    
    /// Creates a new suggestion
    ///
    /// - Parameter req: current request
    func create(_ req: Request) throws -> Future<Response> {
        let futureSuggestion = try req.content.decode(Suggestion.self).flatMap { suggestion in
            return suggestion.save(on: req)
        }
        
        return futureSuggestion.encode(status: .created, for: req)
    }
}
