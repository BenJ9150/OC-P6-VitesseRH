import Vapor

struct UserTokenAuthMiddleware: Middleware {
    
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Check and verify JWT token
        guard let jwtPayload = try? request.jwt.verify(as: UserPayload.self) else {
            return request.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Invalid JWT token"))
        }
        
        return User.query(on: request.db)
            .filter(\.$email, .equal, jwtPayload.email)
            .first()
            .flatMap { fetchedUser in
            if let user = fetchedUser {
                request.auth.login(user)  // Logging in the user for the request lifecycle
                return next.respond(to: request)
            } else {
                return request.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "User not found"))
            }
        }
    }
}
