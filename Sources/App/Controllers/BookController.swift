import Vapor
import FluentPostgreSQL
import Pagination

final class BookController {
    
    /// Obtains the complete list of books
    ///
    /// - Parameter req: current request
    func list(_ req: Request) throws -> Future<Response> {
        if req.hasPagination() {
            return try paginatedList(req).encode(for: req)
        } else {
            return try fullList(req).encode(for: req)
        }
    }
    
    
    /// Obtains the complete list of books without pagination
    ///
    /// - Parameter req: current request
    private func fullList(_ req: Request) -> Future<[Book]> {
        return Book.query(on: req).all()
    }
    
    /// Obtains the requested page from the list of books
    ///
    /// - Parameter req: current request
    private func paginatedList(_ req: Request) throws -> Future<Paginated<Book>> {
        return try Book.query(on: req).paginate(for: req)
    }
    
    /// Obtains the comments from a book
    ///
    /// - Parameter req: current request
    func listComments(_ req: Request) throws -> Future<[Comment.CommentForm]> {
        let futureBook = try req.parameters.next(Book.self)
        
        let futureComments = futureBook.flatMap { book in
            return try book.comments
                .query(on: req)
                .join(\Book.id, to: \Comment.bookID)
                .join(\User.id, to: \Comment.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureComments.map { result in
            return try result.map { entities in
                let (comment, book, user) = (entities.0.0, entities.0.1, entities.1)
                return try Comment.CommentForm(id: comment.requireID(), content: comment.content, user: user, book: book)
            }
        }
        
    }
    
    
    /// Obtains the book's suggestions from another book
    ///
    /// - Parameter req: current request
    func listSuggestedBooks(_ req: Request) throws -> Future<[Book]> {
        let futureBook = try req.parameters.next(Book.self)
        
        let futureSuggestions = futureBook.flatMap { book in
            return Book.query(on: req)
                .filter(\Book.genre == book.genre)
                .filter(\Book.id != book.id)
                .all()
        }
        
        return futureSuggestions
    }
    
    
    /// Obtains a specific book
    ///
    /// - Parameter req: current request
    func show(_ req: Request) throws -> Future<Book> {
        return try req.parameters.next(Book.self)
    }
    
    /// Obtains a specific comment from a book
    ///
    /// - Parameter req: current request
    func showComment(_ req: Request) throws -> Future<Comment.CommentForm> {
        let futureBook = try req.parameters.next(Book.self)
        let futureComment = try req.parameters.next(Comment.self)
        
        let promise = req.eventLoop.newPromise(Comment.CommentForm.self)
        
        DispatchQueue.global(qos: .default).async {
            do {
                let comment = try futureComment.wait()
                let userCall = comment.user.get(on: req)
                let bookCall = comment.book.get(on: req)
                
                let bookToCompare = try futureBook.wait()
                let book = try bookCall.wait()
                if book.id != bookToCompare.id { throw Abort(.notFound) }
                
                let user = try userCall.wait()
                let commentForm = try Comment.CommentForm(id: comment.requireID(),
                                                          content: comment.content,
                                                          user: user,
                                                          book: book)
                promise.succeed(result: commentForm)
            }
            catch {
                promise.fail(error: error)
            }
        }
        
        return promise.futureResult
    }
    
    /// Creates a new book
    ///
    /// - Parameter req: current request
    func create(_ req: Request) throws -> Future<Response> {
        let futureBook = try req.content.decode(Book.self).flatMap { book in
            return book.save(on: req)
        }
        
        return futureBook.encode(status: .created, for: req)
    }
    
    
    /// Creates a comment
    ///
    /// - Parameter req: current request
    func createComment(_ req: Request) throws -> Future<Response> {
        let futureComment = try req.content.decode(Comment.self).flatMap { comment in
            return comment.save(on: req)
        }
        
        return futureComment.encode(status: .created, for: req)
    }
}
