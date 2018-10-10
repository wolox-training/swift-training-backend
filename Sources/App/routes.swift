import Vapor

public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.list)
    router.get("users", User.parameter, use: userController.show)
    router.post("users", use: userController.create)
    router.get("users", User.parameter, "rents", use: userController.listRents)
    router.get("users", User.parameter, "rents", Int.parameter, use: userController.showRent)
    router.post("users", User.parameter, "rents", use: userController.createRent)
    router.get("users", User.parameter, "wishes", use: userController.listWishes)
    router.get("users", User.parameter, "wishes", Int.parameter, use: userController.showWish)
    router.post("users", User.parameter, "wishes", use: userController.createWish)
    router.get("users", User.parameter, "comments", use: userController.listComments)
    
    let bookController = BookController()
    router.get("books", use: bookController.list)
    router.get("books", Book.parameter, use: bookController.show)
    router.post("books", use: bookController.create)
    router.get("books", Book.parameter, "comments", Int.parameter, use: bookController.showComment)
    router.get("books", Book.parameter, "comments", use: bookController.listComments)
    router.post("books", Book.parameter, "comments", use: bookController.createComment)
    router.get("books", Book.parameter, "suggestions", use: bookController.listSuggestedBooks)
}
