import Vapor

struct AdminMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Ensure user is logged in and is an admin
        guard let user = request.auth.get(User.self), user.isAdmin else {
            return request.eventLoop.makeFailedFuture(Abort(.forbidden, reason: "Access restricted to administrators."))
        }
        return next.respond(to: request)
    }
}
