import Vapor
import FluentPostgreSQL

final class UserController {
    
    func list(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
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
                return try Comment.CommentForm(id: comment.requireID(), content: comment.content, user: user, book: book)
            }
        }
 
    }
    
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
                return try Rent.RentForm(id: rent.requireID(), user: user, book: book, from: rent.from, to: rent.to, returnedAt: rent.returnedAt)
            }
        }
    }
    
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
                return try Wish.WishForm(id: wish.requireID(), user: user, book: book)
            }
        }
    }
    
    func show(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    
    func showRent(_ req: Request) throws -> Future<Rent.RentForm> {
        let _ = try req.parameters.next(User.self)
        let rentId = try req.parameters.next(Int.self)
        
        let futureRent = Rent.query(on: req)
            .filter(\Rent.id == rentId)
            .join(\Book.id, to: \Rent.bookID)
            .join(\User.id, to: \Rent.userID)
            .alsoDecode(Book.self)
            .alsoDecode(User.self)
            .first()
        
        
        return futureRent.map { result in
            guard let entities = result else {
                throw Abort(.notFound)
            }
            
            let (rent, book, user) = (entities.0.0, entities.0.1, entities.1)
            return try Rent.RentForm(id: rent.requireID(), user: user, book: book, from: rent.from, to: rent.to, returnedAt: rent.returnedAt)
        }
    }
    
    func showWish(_ req: Request) throws -> Future<Wish.WishForm> {
        let _ = try req.parameters.next(User.self)
        let wishId = try req.parameters.next(Int.self)
        
        let futureWish = Wish.query(on: req)
            .filter(\Wish.id == wishId)
            .join(\Book.id, to: \Wish.bookID)
            .join(\User.id, to: \Wish.userID)
            .alsoDecode(Book.self)
            .alsoDecode(User.self)
            .first()
        
        return futureWish.map { result in
            guard let entities = result else {
                throw Abort(.notFound)
            }
            
            let (rent, book, user) = (entities.0.0, entities.0.1, entities.1)
            return try Wish.WishForm(id: rent.requireID(), user: user, book: book)
        }
    }
    
    func create(_ req: Request) throws -> Future<Response> {
        let futureUser = try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
        
        return futureUser.encode(status: .created, for: req)
    }
    
    func createRent(_ req: Request) throws -> Future<Response> {
        let futureRent = try req.content.decode(Rent.self).flatMap { rent in
            return rent.save(on: req)
        }
        
        return futureRent.encode(status: .created, for: req)
    }
    
    func createWish(_ req: Request) throws -> Future<Response> {
        let futureWish = try req.content.decode(Wish.self).flatMap { wish in
            return wish.save(on: req)
        }
        
        return futureWish.encode(status: .created, for: req)
    }
}
