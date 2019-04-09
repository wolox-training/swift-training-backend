import Vapor
import FluentPostgreSQL

final class UserController {
    
    /// Obtains the complete list of users
    ///
    /// - Parameter req: current request
    func list(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    /// Obtains the comments from a user
    ///
    /// - Parameter req: current request
    func listComments(_ req: Request) throws -> Future<[Comment.CommentForm]> {
        let futureUser = try req.parameters.next(User.self)
        
        let futureComments = futureUser.flatMap { user in
            return try user.comments
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
                return try Comment.CommentForm(id: comment.requireID(), content: comment.content, user: user.getSecuredUser(), book: book)
            }
        }
 
    }
    
    /// Obtains the rents from a user
    ///
    /// - Parameter req: current request
    func listRents(_ req: Request) throws -> Future<[Rent.RentForm]> {
        let futureUser = try req.parameters.next(User.self)
        
        let futureRents = futureUser.flatMap { user in
            return try user.rents
                .query(on: req)
                .join(\Book.id, to: \Rent.bookID)
                .join(\User.id, to: \Rent.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureRents.map { result in
            return try result.map { entities in
                let (rent, book, user) = (entities.0.0, entities.0.1, entities.1)
                return try Rent.RentForm(id: rent.requireID(), user: user.getSecuredUser(), book: book, from: rent.from, to: rent.to, returnedAt: rent.returnedAt)
            }
        }
    }
    
    /// Obtains the wishes from a user
    ///
    /// - Parameter req: current request
    func listWishes(_ req: Request) throws -> Future<[Wish.WishForm]> {
        let futureUser = try req.parameters.next(User.self)
        
        let futureWishes = futureUser.flatMap { user in
            return try user.wishes
                .query(on: req)
                .join(\Book.id, to: \Wish.bookID)
                .join(\User.id, to: \Wish.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureWishes.map { result in
            return try result.map { entities in
                let (wish, book, user) = (entities.0.0, entities.0.1, entities.1)
                return try Wish.WishForm(id: wish.requireID(), user: user.getSecuredUser(), book: book)
            }
        }
    }
    
    
    /// Obtains the current rents from a user
    ///
    /// - Parameter req: current request
    func currentRents(_ req: Request) throws -> Future<[Rent.RentForm]> {
        let futureUser = try req.parameters.next(User.self)
        
        let futureRents = futureUser.flatMap { user in
            return try user.rents
                .query(on: req)
                .filter(\Rent.returnedAt == nil)
                .join(\Book.id, to: \Rent.bookID)
                .join(\User.id, to: \Rent.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureRents.map { result in
            return try result.map { entities in
                let (rent, book, user) = (entities.0.0, entities.0.1, entities.1)
                return try Rent.RentForm(id: rent.requireID(), user: user.getSecuredUser(), book: book, from: rent.from, to: rent.to, returnedAt: rent.returnedAt)
            }
        }
    }
    
    /// Obtains a specific user
    ///
    /// - Parameter req: current request
    func show(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    /// Obtains a specific rent from a user
    ///
    /// - Parameter req: current request
    func showRent(_ req: Request) throws -> Future<Rent.RentForm> {
        let futureUser = try req.parameters.next(User.self)
        let futureRent = try req.parameters.next(Rent.self)
        
        let promise = req.eventLoop.newPromise(Rent.RentForm.self)
        
        DispatchQueue.global(qos: .default).async {
            do {
                let rent = try futureRent.wait()
                let userCall = rent.user.get(on: req)
                let bookCall = rent.book.get(on: req)
                
                let userToCompare = try futureUser.wait()
                let user = try userCall.wait()
                if user.id != userToCompare.id { throw Abort(.notFound) }
                
                let book = try bookCall.wait()
                let rentForm = try Rent.RentForm(id: rent.requireID(),
                                                 user: user.getSecuredUser(),
                                                 book: book,
                                                 from: rent.from,
                                                 to: rent.to,
                                                 returnedAt: rent.returnedAt)
                
                promise.succeed(result: rentForm)
            }
            catch {
                promise.fail(error: error)
            }
        }
        
        return promise.futureResult
    }
    
    /// Obtains a specific wish from a user
    ///
    /// - Parameter req: current request
    func showWish(_ req: Request) throws -> Future<Wish.WishForm> {
        let futureUser = try req.parameters.next(User.self)
        let futureWish = try req.parameters.next(Wish.self)
        
        let promise = req.eventLoop.newPromise(Wish.WishForm.self)
        
        DispatchQueue.global(qos: .default).async {
            do {
                let wish = try futureWish.wait()
                let userCall = wish.user.get(on: req)
                let bookCall = wish.book.get(on: req)
                
                let userToCompare = try futureUser.wait()
                let user = try userCall.wait()
                if user.id != userToCompare.id { throw Abort(.notFound) }
                
                let book = try bookCall.wait()
                let wishForm = try Wish.WishForm(id: wish.requireID(),
                                                 user: user.getSecuredUser(),
                                                 book: book)
                
                promise.succeed(result: wishForm)
            }
            catch {
                promise.fail(error: error)
            }
        }
        
        return promise.futureResult
    }
    
    /// Creates a new user
    ///
    /// - Parameter req: current request
    func create(_ req: Request) throws -> Future<Response> {
        let futureUser = try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
        
        return futureUser.encode(status: .created, for: req)
    }
    
    /// Creates a new rent
    ///
    /// - Parameter req: current request
    func createRent(_ req: Request) throws -> Future<Response> {
        let futureRent = try req.content.decode(Rent.self).flatMap { rent -> Future<(Rent)> in
            rent.book.get(on: req).flatMap { book -> Future<(Book)> in
                book.status = "Rented"
                return book.save(on: req)
            }
            
            return rent.save(on: req)
        }
        
        return futureRent.encode(status: .created, for: req)
    }
    
    /// Creates a new wish
    ///
    /// - Parameter req: current request
    func createWish(_ req: Request) throws -> Future<Response> {
        let futureWish = try req.content.decode(Wish.self).flatMap { wish in
            return wish.save(on: req)
        }
        
        return futureWish.encode(status: .created, for: req)
    }
}
