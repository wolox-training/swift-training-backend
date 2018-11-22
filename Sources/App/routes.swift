import Vapor

/// Sets up the router by linking each path to a controller method
///
/// - Parameter router: object responsible for registering the URI paths
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.list)
    router.get("users", User.parameter, use: userController.show)
    router.post("users", use: userController.create)
    router.get("users", User.parameter, "rents", use: userController.listRents)
    router.get("users", User.parameter, "rents", Rent.parameter, use: userController.showRent)
    router.post("users", User.parameter, "rents", use: userController.createRent)
    router.get("users", User.parameter, "wishes", use: userController.listWishes)
    router.get("users", User.parameter, "wishes", Wish.parameter, use: userController.showWish)
    router.post("users", User.parameter, "wishes", use: userController.createWish)
    router.get("users", User.parameter, "comments", use: userController.listComments)
    
    let bookController = BookController()
    router.get("books", use: bookController.list)
    router.get("books", Book.parameter, use: bookController.show)
    router.post("books", use: bookController.create)
    router.get("books", Book.parameter, "comments", use: bookController.listComments)
    router.get("books", Book.parameter, "comments", Comment.parameter, use: bookController.showComment)
    router.post("books", Book.parameter, "comments", use: bookController.createComment)
    router.get("books", Book.parameter, "suggestions", use: bookController.listSuggestedBooks)

    let suggestionController = SuggestionController()
    router.get("suggestions", use: suggestionController.list)
    router.get("suggestions", Suggestion.parameter, use: suggestionController.show)
    router.post("suggestions", use: suggestionController.create)
}
