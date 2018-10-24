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
        
        let promise = req.eventLoop.newPromise(Suggestion.SuggestionForm.self)
        
        DispatchQueue.global(qos: .default).async {
            do {
                let suggestion = try futureSuggestion.wait()
                let userCall = suggestion.user.get(on: req)
                let user = try userCall.wait()
                
                let suggestionForm = try Suggestion.SuggestionForm(id: suggestion.requireID(),
                                                                   title: suggestion.title,
                                                                   author: suggestion.author,
                                                                   link: suggestion.link,
                                                                   user: user)
                promise.succeed(result: suggestionForm)
            }
            catch {
                promise.fail(error: error)
            }
        }
        
        return promise.futureResult
    }
    
    func create(_ req: Request) throws -> Future<Response> {
        let futureSuggestion = try req.content.decode(Suggestion.self).flatMap { suggestion in
            return suggestion.save(on: req)
        }
        
        return futureSuggestion.encode(status: .created, for: req)
    }
}
