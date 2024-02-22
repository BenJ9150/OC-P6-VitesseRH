import Vapor
import Fluent


struct RegisterRequest: Content {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct LoginRequest: Content {
    let email: String
    let password: String
}


final class UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("user")
        
        usersRoute.post("register", use: register)
            .description("Register a new user")
        
    
        usersRoute.post("auth", use: login)
            .description("Authenticate a user and return a JWT token")
    }

    func register(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let registerRequest = try req.content.decode(RegisterRequest.self)

        // Hash the password
        let passwordHash = try req.password.hash(registerRequest.password)
        let user = User(firstName: registerRequest.firstName,
                        lastName: registerRequest.lastName,
                        email: registerRequest.email,
                        passwordHash: passwordHash,
                        isAdmin: false)

        return user.save(on: req.db).map { _ in .created }
    }

    func login(req: Request) async throws -> TokenResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)

        let user = try await User.query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first()
        
        guard let findUser = user else {
            throw Abort(.unauthorized, reason: "User not found.")
        }
        
        guard try req.password.verify(loginRequest.password, created: findUser.passwordHash) else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }
        
        let payload = UserPayload(email: findUser.email, isAdmin: findUser.isAdmin)
        return TokenResponse(token: try req.jwt.sign(payload), isAdmin: findUser.isAdmin)
    }

}

struct TokenResponse: Content {
    let token: String
    let isAdmin: Bool
}
