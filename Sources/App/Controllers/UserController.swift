import Vapor
import FluentPostgreSQL

final class UserController: BaseController {
    
    func list(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func listComments(_ req: Request) throws -> Future<Response> {
        let futureComments = try req.parameters.next(User.self).flatMap { user in
            return try user.comments
                .query(on: req)
                .join(\Book.id, to: \Comment.bookID)
                .join(\User.id, to: \Comment.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureComments.map { tuples in
            
            let data = tuples.map { [unowned self] tuple in
                self.createComment(comment: tuple.0.0, book: tuple.0.1, user: tuple.1)
            }
            
            return try self.createGetResponse(req, content: data)
        }
        
    }
    
    func listRents(_ req: Request) throws -> Future<Response> {
        let futureRents = try req.parameters.next(User.self).flatMap { user in
            return try user.rents
                .query(on: req)
                .join(\Book.id, to: \Rent.bookID)
                .join(\User.id, to: \Rent.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureRents.map { tuples in
            
            let data = tuples.map { [unowned self] tuple in
                self.createRent(rent: tuple.0.0, book: tuple.0.1, user: tuple.1)
            }
            
            return try self.createGetResponse(req, content: data)
        }
    }
    
    func listWishes(_ req: Request) throws -> Future<Response> {
        let futureWishes = try req.parameters.next(User.self).flatMap { user in
            return try user.wishes
                .query(on: req)
                .join(\Book.id, to: \Wish.bookID)
                .join(\User.id, to: \Wish.userID)
                .alsoDecode(Book.self)
                .alsoDecode(User.self)
                .all()
        }
        
        return futureWishes.map { tuples in
            
            let data = tuples.map { [unowned self] tuple in
                self.createWish(wish: tuple.0.0, book: tuple.0.1, user: tuple.1)
            }
            
            return try self.createGetResponse(req, content: data)
        }
    }
    
    func show(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    
    func showRent(_ req: Request) throws -> Future<Response> {
        let user = try req.parameters.next(User.self)
        let rentId = try req.parameters.next(Int.self)
        
        let futureRents = Rent.query(on: req)
            .filter(\Rent.id == rentId)
            .join(\Book.id, to: \Rent.bookID)
            .join(\User.id, to: \Rent.userID)
            .alsoDecode(Book.self)
            .alsoDecode(User.self)
            .first()
        
        return futureRents.map { [unowned self] tuple in
            let data = self.createRent(rent: tuple!.0.0, book: tuple!.0.1, user: tuple!.1)
            return try self.createGetResponse(req, content: data)
        }
    }
    
    func showWish(_ req: Request) throws -> Future<Response> {
        let user = try req.parameters.next(User.self)
        let wishId = try req.parameters.next(Int.self)
        
        let futureWishes = Wish.query(on: req)
            .filter(\Wish.id == wishId)
            .join(\Book.id, to: \Wish.bookID)
            .join(\User.id, to: \Wish.userID)
            .alsoDecode(Book.self)
            .alsoDecode(User.self)
            .first()
        
        return futureWishes.map { [unowned self] tuple in
            let data = self.createWish(wish: tuple!.0.0, book: tuple!.0.1, user: tuple!.1)
            return try self.createGetResponse(req, content: data)
        }
    }
    
    func create(_ req: Request) throws -> Future<Response> {
        let futurePost = try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
        
        return futurePost.map { [unowned self] user in
            return try self.createPostResponse(req, content: user)
        }
    }
    
    func createRent(_ req: Request) throws -> Future<Response> {
        let futurePost = try req.content.decode(Rent.self).flatMap { rent in
            return rent.save(on: req)
        }
        
        return futurePost.map { [unowned self] rent in
            return try self.createPostResponse(req, content: rent)
        }
    }
    
    func createWish(_ req: Request) throws -> Future<Response> {
        let futurePost = try req.content.decode(Wish.self).flatMap { wish in
            return wish.save(on: req)
        }
        
        return futurePost.map { [unowned self] wish in
            return try self.createPostResponse(req, content: wish)
        }
    }
}
