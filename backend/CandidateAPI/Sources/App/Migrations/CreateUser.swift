import Fluent
import Vapor


struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email") // to ensure unique emails
            .field("password_hash", .string, .required)
            .field("is_admin", .bool, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}

struct AddAdmin: Migration {
    private let passwordHash: String
    
    init(withHashedPassword passwordHash: String) {
        self.passwordHash = passwordHash
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let user = User(firstName: "Admin", 
                        lastName: "Admin",
                        email: "admin@vitesse.com",
                        passwordHash: passwordHash,
                        isAdmin: true)
        return user.save(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).delete()
    }
}
