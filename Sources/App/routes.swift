import Vapor

public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.list)
    //router.get("users", use: userController.list)
    router.get("users", User.parameter, use: userController.show)
    router.post("users", use: userController.create)
    router.get("users", User.parameter, "rents", use: userController.listRents)
    router.get("users", User.parameter, "rents", Int.parameter, use: userController.showRent)
    router.post("users", User.parameter, "rents", use: userController.createRent)
    router.get("users", User.parameter, "wishes", use: userController.listWishes)
    router.get("users", User.parameter, "wishes", Int.parameter, use: userController.showWish)
    router.post("users", User.parameter, "wishes", use: userController.createWish)
    router.get("users", User.parameter, "comments", use: userController.listComments)
}
